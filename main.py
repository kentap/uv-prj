def greet():
    print("Hello from uv-prj!")

def sum(a: int, b: int) -> int:
    return a + b

def run_logic():
    greet()
    result = sum(5, 3)
    print(f"The answer is: {result}")

def lambda_handler(event, context):
    run_logic()
    return {
        'statusCode': 200,
        'body': 'Function executed successfully!'
    }   

if __name__ == "__main__":
    run_logic()
