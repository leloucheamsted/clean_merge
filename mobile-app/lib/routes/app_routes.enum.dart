enum AppRoute {
  initial("/"),
  splash("/splash/"),
  onboarding("/onboarding/"),
  home("/home/"),

  test("/test/"),
  clearSession("/test/clear_session/"),
  circleTest("/test/circle_test/"),

  auth("/auth/"),
  otp("/auth/otp/"),

  contacts("/contacts/"),

  user("/user/"),
  userProfileCurrent("/user/profile"),
  userProfileEdit("/user/profile/edit"),
  userProfile("/user/profile/:uid"),

  group("/group/"),
  groupHome("/group/home"),
  groupList("/group/list"),
  groupCreate("/group/create"),
  groupEdit("/group/edit/:id"),
  groupDetail("/group/detail/:id"),
  groupMessages("/group/messages/:id"),

  ptt("/ptt/"),
  pttTest("/ptt/test"),
  ;

  String get pathAsChild {
    final List l = path.split("/");
    l.removeAt(0);
    if (path.startsWith("/")) {
      l.removeAt(0);
    }
    final String t = "/${l.join("/")}";
    return t;
  }

  const AppRoute(this.path);
  final String path;
  String withIdParam(String value) {
    return path.replaceAll(":id", value);
  }
}
