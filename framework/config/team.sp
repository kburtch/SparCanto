separate;

team       : teams.member;
ken_burtch : teams.member;

procedure setup_team is
begin
  team.description := "SparCanto team";
  team.is_team := true;

  ken_burtch.description := "";
  ken_burtch.skills := "Ada Basic Java Groovy Perl PHP Python Shell";
  ken_burtch.lang := "English";
  ken_burtch.full_name := "Ken Burtch";
  ken_burtch.nickname := "Ken";
  ken_burtch.roles     := "programmer";
  ken_burtch.is_team := false;
end setup_team;

-- VIM editor formatting instructions
-- vim: ft=spar

