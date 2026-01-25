import os
import time
import json
import random
import traceback
import asyncio

from loguru import logger
import string
import secrets
from faker import Faker
from get_token import get_access_token
from playwright.async_api import async_playwright


def generate_strong_password(length=16):
    chars = string.ascii_letters + string.digits + "!@#$%^&*"
    while True:
        password = ''.join(secrets.choice(chars) for _ in range(length))
        if (any(c.islower() for c in password)
                and any(c.isupper() for c in password)
                and any(c.isdigit() for c in password)
                and any(c in "!@#$%^&*" for c in password)):
            return password


def random_email(length):
    first_char = random.choice(string.ascii_lowercase)
    other_chars = []
    for _ in range(length - 1):
        if random.random() < 0.07:
            other_chars.append(random.choice(string.digits))
        else:
            other_chars.append(random.choice(string.ascii_lowercase))
    return first_char + ''.join(other_chars)


async def OpenBrowser(playwright):
    try:
        launch_args = {
            "headless": headless_mode,
            "proxy": {
                "server": proxy,
                "bypass": "localhost",
            },
        }
        if browser_path:
            launch_args["executable_path"] = browser_path
            
        browser = await playwright.chromium.launch(**launch_args)
        return browser
    except Exception as e:
        error = traceback.format_exc()
        logger.error(error)
        return None


async def Outlook_register(page, email, password):
    fake = Faker()
    lastname = fake.last_name()
    firstname = fake.first_name()
    year = str(random.randint(1960, 2005))
    month = str(random.randint(1, 12))
    day = str(random.randint(1, 28))

    try:
        await page.goto("https://outlook.live.com/mail/0/?prompt=create_account", timeout=20000,
                        wait_until="domcontentloaded")
        await page.get_by_text('同意并继续').wait_for(timeout=30000)
        start_time = time.time()
        await page.wait_for_timeout(2000)
        await page.get_by_text('同意并继续').click(timeout=30000)
    except:
        print("[Error: IP] - IP质量不佳，无法进入注册界面。 ")
        return False

    try:
        await page.locator('[aria-label="新建电子邮件"]').type(email, delay=80, timeout=10000)
        await page.locator('[data-testid="primaryButton"]').click(timeout=5000)
        await page.wait_for_timeout(400)
        await page.locator('[type="password"]').type(password, delay=60, timeout=10000)
        await page.wait_for_timeout(400)
        await page.locator('[data-testid="primaryButton"]').click(timeout=5000)

        await page.wait_for_timeout(500)
        await page.locator('[name="BirthYear"]').fill(year, timeout=10000)

        try:
            await page.wait_for_timeout(600)
            await page.locator('[name="BirthMonth"]').select_option(value=month, timeout=2000)
            await page.wait_for_timeout(1200)
            await page.locator('[name="BirthDay"]').select_option(value=day)
        except:
            await page.locator('[name="BirthMonth"]').click()
            await page.wait_for_timeout(400)
            await page.locator(f'[role="option"]:text-is("{month}月")').click()
            await page.wait_for_timeout(1200)
            await page.locator('[name="BirthDay"]').click()
            await page.wait_for_timeout(400)
            await page.locator(f'[role="option"]:text-is("{day}日")').click()

        await page.locator('[data-testid="primaryButton"]').click(timeout=5000)
        await page.locator('#lastNameInput').type(lastname, delay=120, timeout=10000)
        await page.wait_for_timeout(700)
        await page.locator('#firstNameInput').fill(firstname, timeout=10000)

        if time.time() - start_time < bot_protection_wait:
            await page.wait_for_timeout((bot_protection_wait - time.time() + start_time) * 1000)

        await page.locator('[data-testid="primaryButton"]').click(timeout=5000)
        await page.locator('span > [href="https://go.microsoft.com/fwlink/?LinkID=521839"]').wait_for(state='detached',
                                                                                                      timeout=22000)
        await page.wait_for_timeout(400)

        if await page.get_by_text('一些异常活动').count() > 0:
            print("[Error: IP or broswer] - 当前IP注册频率过快。检查IP与是否为指纹浏览器并关闭了无头模式。")
            return False

        if await page.locator('iframe#enforcementFrame').count() > 0:
            print("[Error: FunCaptcha] - 验证码类型错误，非按压验证码。 ")
            return False

        await page.wait_for_event("request", lambda req: req.url.startswith("blob:https://iframe.hsprotect.net/"),
                                  timeout=22000)
        await page.wait_for_timeout(800)
        await page.keyboard.press('Tab')
        await page.keyboard.press('Tab')
        await page.wait_for_timeout(100)

        for _ in range(0, max_captcha_retries + 1):
            await page.keyboard.press('Enter')
            await page.wait_for_timeout(11000)
            await page.keyboard.press('Enter')
            await page.wait_for_event("request",
                                      lambda req: req.url.startswith("https://browser.events.data.microsoft.com"),
                                      timeout=40000)

            try:
                await page.wait_for_event("request",
                                          lambda req: req.url.startswith("blob:https://iframe.hsprotect.net/"),
                                          timeout=1700)
            except:
                try:
                    await page.get_by_text('一些异常活动').wait_for(timeout=1200)
                    print("[Error: Rate limit] - 正常通过验证码，但当前IP注册频率过快。")
                    return False
                except:
                    pass
                await page.wait_for_timeout(500)
                break
        else:
            raise TimeoutError

    except:
        print(f"[Error: IP] - 加载超时或因触发机器人检测导致按压次数达到最大仍未通过。")
        return False

    filename = 'Results\\logged_email.txt' if enable_oauth2 else 'Results\\unlogged_email.txt'
    with open(filename, 'a', encoding='utf-8') as f:
        f.write(f"{email}@outlook.com: {password}\n")
    print(f'[Success: Email Registration] - {email}@outlook.com: {password}')

    if not enable_oauth2:
        return True

    try:
        await page.locator('[data-testid="secondaryButton"]').click(timeout=20000)
        button = page.locator('[data-testid="secondaryButton"]')
        await button.wait_for(timeout=5000)
    except:
        print(f"[Error: Timeout] - 无法找到按钮。")
        return False

    try:
        await page.wait_for_timeout(random.randint(1600, 2000))
        await button.click(timeout=6000)
        button = page.locator('[data-testid="secondaryButton"]')
        await button.wait_for(timeout=5000)
        await page.wait_for_timeout(random.randint(1600, 2000))
        await button.click(timeout=6000)
        button = page.locator('[data-testid="secondaryButton"]')
        await button.wait_for(timeout=5000)
        await page.wait_for_timeout(3000)
        await button.click(timeout=6000)
    except:
        pass

    try:
        await page.wait_for_timeout(3200)
        if await page.get_by_text("保持登录状态?").count() > 0:
            await page.get_by_text('否').click(timeout=12000)
        await page.locator('.splitPrimaryButton[aria-label="新邮件"]').wait_for(timeout=26000)
        return True
    except:
        print(f'[Error: Timeout] - 邮箱未初始化，无法正常收件。')
        return False


async def process_single_flow():
    browser = None
    playwright = None
    try:
        playwright = await async_playwright().start()
        browser = await OpenBrowser(playwright)
        if not browser:
            return False

        page = await browser.new_page()
        email = random_email(random.randint(12, 14))
        password = generate_strong_password(random.randint(11, 15))
        result = await Outlook_register(page, email, password)

        if result and not enable_oauth2:
            return True
        elif not result:
            return False

        token_result = get_access_token(page, email)
        if token_result[0]:
            refresh_token, access_token, expire_at = token_result
            with open(r'Results\outlook_token.txt', 'a') as f2:
                f2.write(
                    email + "@outlook.com---" + password + "---" + refresh_token + "---" + access_token + "---" + str(
                        expire_at) + "\n")
            print(f'[Success: TokenAuth] - {email}@outlook.com')
            return True
        else:
            return False
    except:
        return False
    finally:
        if browser:
            await browser.close()
        if playwright:
            await playwright.stop()


async def main(concurrent_flows=10, max_tasks=1000):
    task_counter = 0
    succeeded_tasks = 0
    failed_tasks = 0
    running_tasks = set()

    while task_counter < max_tasks or len(running_tasks) > 0:
        done_tasks = {t for t in running_tasks if t.done()}
        for task in done_tasks:
            try:
                result = await task
                if result:
                    succeeded_tasks += 1
                else:
                    failed_tasks += 1
            except Exception as e:
                failed_tasks += 1
                print(e)
            running_tasks.remove(task)

        while len(running_tasks) < concurrent_flows and task_counter < max_tasks:
            await asyncio.sleep(0.2)
            new_task = asyncio.create_task(process_single_flow())
            running_tasks.add(new_task)
            task_counter += 1

        await asyncio.sleep(0.5)

    print(f"[Info: Result] - 共 {max_tasks} 个，成功 {succeeded_tasks}，失败 {failed_tasks}")


if __name__ == '__main__':
    with open('config.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    os.makedirs("Results", exist_ok=True)

    # 优先从环境变量读取配置，方便 GitHub Actions 调用
    browser_path = os.environ.get('BROWSER_PATH', data.get('browser_path', ''))
    # 如果 browser_path 为空字符串或 "None"，则设为 None，使用 Playwright 自带浏览器
    if not browser_path or browser_path.lower() == "none":
        browser_path = None

    bot_protection_wait = int(os.environ.get('BOT_PROTECTION_WAIT', data.get('Bot_protection_wait') or 15))
    max_captcha_retries = int(os.environ.get('MAX_CAPTCHA_RETRIES', data.get('max_captcha_retries') or 3))
    
    # 代理设置
    proxy = os.environ.get('PROXY', data.get('proxy'))
    
    enable_oauth2 = os.environ.get('ENABLE_OAUTH2', str(data.get('enable_oauth2', False))).lower() == 'true'
    concurrent_flows = int(os.environ.get('CONCURRENT_FLOWS', data.get('concurrent_flows') or 1))
    max_tasks = int(os.environ.get('MAX_TASKS', data.get('max_tasks') or 30))

    # 是否开启无头模式 (GitHub Actions 默认开启，本地调试默认关闭)
    headless_mode = os.environ.get('HEADLESS', 'False').lower() == 'true'

    asyncio.run(main(concurrent_flows, max_tasks))