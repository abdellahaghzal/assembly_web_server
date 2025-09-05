# Assembly Web Server

This project is a minimalist HTTP web server written entirely in x86-64 assembly language for Linux. It is designed to be a lightweight server that handles basic GET and POST requests.

## Functionality

*   **GET Requests:** The server can serve static files. For example, a `GET <path_to_file>` request will return the contents of the file.
*   **POST Requests:** The server can accept POST requests and save the body of the request to a specified file. For example, a `POST <path_to_file>` request will write the request's body to the file.

## Building and Running

To build and run the server, you will need `gcc`.

1.  **Build the server:**
    ```bash
    as -o "server.o" "server.s" && ld -o server "server.o" && rm -f "server.o"
    ```

2.  **Run the server:**
    The server listens on port 80, which is a privileged port. Therefore, you must run it with `sudo`.
    ```bash
    sudo ./server
    ```

## Usage

You can interact with the server using a tool like `curl`.

*   **To request a file (GET):**
    First, create a file for the server to serve:
    ```bash
    echo "Hello, World!" > <path_to_file>
    ```
    Then, in another terminal, run:
    ```bash
    curl http://localhost/<path_to_file>
    ```

*   **To upload a file (POST):**
    ```bash
    curl -X POST --data "This is some data." http://localhost/<path_to_file>
    ```
    This will create a file on the server with the content "This is some data.".
