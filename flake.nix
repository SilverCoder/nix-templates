{
  "description" = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      bevy = {
        path = ./bevy;
        description = "Bevy template";
      };
    };
  };
}
