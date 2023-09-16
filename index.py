import tkinter as tk

def change_value_to(new_value):
    if new_value == 100:
        root.configure(background="green")
        label.config(text="Value: 100", bg="green")
    elif new_value == 0:
        root.configure(background="red")
        label.config(text="Value: 0", bg="red")

def check_value(initial_value):
    # Initialize the main window
    global root  # Make it global to access in change_value_to
    root = tk.Tk()
    root.title("Value Checker")
    root.geometry("300x200")

    global label  # Make it global to modify in change_value_to
    if initial_value == 100:
        label_text = "Value: 100"
        bg_color = "green"
    elif initial_value == 0:
        label_text = "Value: 0"
        bg_color = "red"
        root.after(4000, lambda: change_value_to(100))  # Schedule a value change to 100 after 4000ms (4 seconds)

    label = tk.Label(root, text=label_text, bg=bg_color, font=("Arial", 16))
    label.pack(pady=70)  # Center the label vertically

    # Run the GUI loop
    root.mainloop()

# Test the function with an initial value of 0
check_value(0)
