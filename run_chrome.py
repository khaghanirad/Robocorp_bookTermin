from selenium.webdriver import ChromeOptions

def add_remote_debug_port(options, port):
    options.add_experimental_option("debuggerAddress", f"localhost:{port}")


