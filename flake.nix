{
  "description" = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      bevy = {
        path = ./bevy;
        description = "Bevy template";
      };
      node = {
        path = ./node;
        description = "Node.js template";
      };
    };
  };
}
