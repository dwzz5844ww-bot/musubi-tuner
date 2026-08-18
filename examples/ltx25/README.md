Steps To Follow

1. Inside the config folder is an config\_example.toml that will NEED to be edited to reflect
the true paths to your cache\_directory and image\_directory.

Note: If you change the name of a file... be sure any references to that file are changed
within config.toml, and the batch files.

2. Edit each Batch File. Give each a unique, but descriptive name. Inside each batch file
are C:\\Path\_to... that will need to be updated for Musubi-LTX SCM to work.

3\. Place your training images and matching caption files in the dataset folder.



A small identity dataset may contain roughly 15-30 well-selected images, but the

appropriate number depends on the subject and training goal. Background removal

is optional; use the dataset preparation approach appropriate for your project.



Each image should have a caption file with the same base name:



Image1.png

Image1.txt

Image2.png

Image2.txt



4\. If you are training a subject LoRA, captions may begin with a consistent trigger

token. For example:



example\_token\_word, front profile, slightly smiling, hair up, standing



Captions may use tags, natural language, or another consistent captioning style.



Note: The commas are required except for the last caption.

5. Once all that is complete and you have double-verified your batch files, you can run
cache\_latents\_example.bat (or whatever you named this file). It should be relatively
quick and it will tell you once it is done...then click any key to continue to close
the terminal. Check your cache folder and you should see the number of .safetensors cache
files that equals the number of images you have.
6. Now we run cache\_text\_encoder\_example.bat (or whatever you renamed it to). This process
can take substantially longer to complete. On an RTX 5060ti 16GB, it can take upwards of
20 minutes depending on the number of images. Be patient! It will tell you when it is
complete. Check your cache folder and you should see the same number of .safetensors for
text cache.
7. Run the smoke\_test\_lora\_example.bat (Or whatever you rename this to). This is a training
batch file, but it only runs a single step just to see if everything is working correctly as
intended. If this performs correctly, then you can move on to the next step.
8. Run a full training with the train\_lora\_example.bat (or whatever you renamed it to). You
should be patient as this can take anywhere from a couple hours or longer depending on your
machine, or number of images. You should see that when it is running a timer that estimates
the length of time for completion.

Note: If it is too long for you, to stop a training you can close the terminal or chose
Ctrl-C which will abort the process.
Note: The example uses 2000 training steps because that configuration has been tested

successfully on the validated SCM setup. The appropriate step count depends on

dataset size, repeats, learning rate, LoRA rank, and the subject being trained.



If training time is excessive, reduce --max\_train\_steps and evaluate the resulting

LoRA. There is no universal minimum or ideal step count.

9. Once the full training is complete you should find some .safetensors in your output
directory. Try the one without numbers first.
IF you are using ComfyUI...then use the .comfy.safetensors file
IF you are using another platform, then you *may* need the other version.
Rename your new LoRA to something descriptive (if you didn't already do so inside the
train\_lora\_example.bat) such as CharacterName\_LoRA\_LTX25.safetensors
10. Move the file to your models\\loras directory for ComfyUI which is commonly found here:

C:\\Users\\User\_Name\\AppData\\Local\\Comfy-Desktop\\ComfyUI-Installs\\Instance\_Name\\ComfyUI\\models\\loras

Where User\_Name is your Windows account name
and Instance\_Name is what instance you are running inside of ComfyUI.

\\

