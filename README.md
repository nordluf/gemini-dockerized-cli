# Gemini Dockerized CLI (GDCLI)

**GDCLI** provides a simplified, containerized wrapper for the Gemini CLI, offering **improved usability** and a **safer workflow**. It allows you to run the Gemini CLI without concern for unintended or potentially dangerous system actions, ensuring a clean and isolated environment.

## 🛠️ How to Use

To start using GDCLI, navigate to your project directory and run the following command:

```bash
docker run --rm -it -v ./:/app/ hlpr/gdcli
```

**Initialization:** If the project directory lacks an existing `./llm/.gemini.store` directory, GDCLI will automatically **initialize** it by copying default settings and prompts. It then symlinks this directory as the standard `~/.gemini/` folder inside the container, preparing the repository for Gemini usage.

## Key Features

* **Preconfigured Environment:** Ready-to-use Gemini CLI environment with **Context7 integration** for enhanced contextual awareness.
* **Project Specifications:** Utilizes the **`llm/PROJECT.md`** file to hold project-specific specifications and context for the model.
* **Custom Preseed Option:** Easily share authentication or configuration information from another project using a custom preseed directory.

### Custom Preseed Usage

To mount and use a custom preseed directory, include the `-v` flag to map your custom path to the container's `/preseed/` directory:

```bash
docker run --rm -it -v /path/to/your/preseed/directory/:/preseed/ -v ./:/app/ hlpr/gdcli
```

*(Note: Replace `/path/to/your/preseed/directory/` with the actual path on your host machine.)*
