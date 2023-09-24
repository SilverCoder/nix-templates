{
  "description" = "A collection of flake templates";

  outputs = { self }: {
    templates = {
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
    };
  };
}
