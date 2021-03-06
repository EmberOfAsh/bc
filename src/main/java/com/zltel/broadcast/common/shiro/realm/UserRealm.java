package com.zltel.broadcast.common.shiro.realm;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Lazy;

import com.zltel.broadcast.common.exception.RRException;
import com.zltel.broadcast.common.util.AdminRoleUtil;
import com.zltel.broadcast.common.util.Constant;
import com.zltel.broadcast.um.bean.SysMenu;
import com.zltel.broadcast.um.bean.SysUser;
import com.zltel.broadcast.um.service.SysMenuService;
import com.zltel.broadcast.um.service.SysUserService;



public class UserRealm extends AuthorizingRealm {
    /** 日志输出对象 **/

    private static final Logger logout = LoggerFactory.getLogger(UserRealm.class);


    public static final String REALM_NAME = "UserPassWordRealm";

    @Resource
    @Lazy
    private SysUserService sysUserService;

    @Resource
    @Lazy
    private SysMenuService sysMenuService;


    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        SysUser user = (SysUser) principals.getPrimaryPrincipal();
        logout.info("查找{}权限", user.getUsername());
        Integer userId = user.getUserId();
        // 查询用户具有的角色
        Set<String> roles = new HashSet<>(this.sysUserService.queryAllRoles(userId));

        List<String> permsList = null;
        // 系统管理员 | 平台管理员 ，拥有最高权限,
        if (userId == Constant.SUPER_ADMIN || AdminRoleUtil.isPlantAdmin(roles)) {
            logout.info("平台管理员: {} 登录,加载平台所有权限", user.getUsername());
            List<SysMenu> menuList = sysMenuService.queryForList(null);
            permsList = menuList.stream().map(SysMenu::getPerms).collect(Collectors.toList());
        } else {
            permsList = this.sysUserService.queryAllPerms(userId);
        }
        // 用户权限列表
        Set<String> permsSet =
                permsList.stream().filter(StringUtils::isNotBlank).flatMap(s -> Arrays.stream(s.split(",")))// 多个权限描述字符串
                        .collect(Collectors.toSet());



        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        authorizationInfo.setRoles(roles);
        authorizationInfo.setStringPermissions(permsSet);

        return authorizationInfo;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) {
        logout.info("尝试使用 用户名/密码方式登陆");
        SimpleAuthenticationInfo authenticationInfo = null;
        String username = (String) token.getPrincipal();
        SysUser user = this.sysUserService.selectByUserName(username);
        if (user == null) throw new UnknownAccountException();
        if (!user.getStatus()) RRException.makeThrow("账户已被禁用");

        authenticationInfo = new SimpleAuthenticationInfo(user, // 用户名
                user.getPassword(), // 密码
                ByteSource.Util.bytes(user.getSalt()), // salt=username
                getName() // realm name
        );
        return authenticationInfo;
    }

    @Override
    public String getName() {
        return REALM_NAME;
    }



}
