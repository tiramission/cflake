inputs: {
  # 与 lib.optionals 相反的函数：先接受模块列表，再接受条件
  includeif = modules: condition: lib.optionals condition (lib.toList modules);
  # 选择同版本时优先级更高的包，即第一个包
  pkgshould = prio: next:
    if prio.version == next.version
    then prio
    else next;
}
