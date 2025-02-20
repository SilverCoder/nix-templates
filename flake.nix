{
  "description" = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      bare = {
        path = ./bare;
        description = "Bare template";
      };
      bevy = {
        path = ./bevy;
        description = "Bevy template";
      };
      flutter = {
        path = ./flutter;
        description = "Flutter template";
      };
      node = {
        path = ./node;
        description = "Node.js template";
      };
      tauri = {
        path = "./tauri";
        description = "Tauri template";
      };
    };
  };
}
