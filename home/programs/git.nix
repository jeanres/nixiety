{ config, lib, ... }:
let
  email = "jeanres@icloud.com";
  # Public key used to sign commits (safe to commit; it's the .pub half)
  signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKRykGwvrsjlEt8Eoz19//n0/hfVjcWQKfBtf88qjgShD5VSWwtQQ7TnVeQLe4BLZiaKGMZslHcrurlbzLGyKbg2BI+s2irvoLfJ2/n1pCpObBzkzBNTU0Wa1D5AScQ3taNn1UU1uMR83hl5HQvf2KlFmD5/veSC3JFz0jygBhnWxpQRyPuy5+JsMndFJFmurKzLl+FfoZsRHmPBmqtQRB2fLki1flTg2XvQIIhsQF+RBTJJig4KyYMNmx7SoY3Rl9aqNm0o/a50ahEgcJWhmIAcerwVZmlJf+snmLz/Trc1widLj7tihcqsnosQcgRTiDyRLj5YSgMxqIEKu43dWu5xJXFVfh2vR56Sczr2oQ2UIEje3YuXBio8p2ebqhS12Yu/aA+M/LD5c/C90JGL4nLQgWq/KxaSGHf8t8DOKMeodtC7jvqKEt/+KtS+ugTOobzhV94s1QzEI4Mk0t5IGo7mWSm8y+sCYIUdcwrIvVmJDfQ6aaLPLGKx5zlv3awDM=";
in
{
  programs.git = {
    enable = lib.mkDefault true;

    settings = {
      user = {
        name = "Jeanre Swanepoel";
        inherit email;
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoStash = true;
      rerere.enabled = true; # remember how conflicts were resolved
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      help.autocorrect = "prompt";

      alias = {
        st = "status -sb";
        co = "checkout";
        sw = "switch";
        br = "branch";
        ci = "commit";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
        lg = "log --graph --oneline --decorate --all";
        last = "log -1 HEAD --stat";
      };
    };

    # Sign commits and tags with the SSH key
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      signByDefault = true;
      allowedSigners = "${email} ${signingKey}";
    };

    # Global gitignore
    ignores = [
      ".DS_Store"
      ".direnv/"
      "*.swp"
      "*~"
    ];
  };
}
