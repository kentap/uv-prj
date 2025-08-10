def greet():
    print("Hello from uv-prj!")

def sum(a: int, b: int) -> int:
    return a + b

def main():
    greet()
    result = sum(5, 3)
    print(f"The sum of 5 and 3 is: {result}")   

if __name__ == "__main__":
    main()
