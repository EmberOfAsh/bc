package com.zltel.broadcast.template.controller;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.zltel.broadcast.common.controller.BaseController;
import com.zltel.broadcast.common.json.R;
import com.zltel.broadcast.common.validator.ValidatorUtils;
import com.zltel.broadcast.template.bean.TemplateContent;
import com.zltel.broadcast.template.service.TemplateContentService;
import com.zltel.broadcast.um.bean.SysUser;

import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;

@RestController
@RequestMapping("/tp")
public class TemplateContentController extends BaseController{
    public static final Logger logout = LoggerFactory.getLogger(TemplateContentController.class);
    @Resource
    private TemplateContentService templateContentService;

    @ApiOperation(value = "查询分类模板列表", notes = "根据用户所在组织查询其指定模板类别下的模板信息")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "tpTypeId", value = "分类id", required = true, dataType = "Integer", paramType = "query")})
    @RequestMapping(value = "/listByType", method = {RequestMethod.GET})
    public R listTpByType(TemplateContent tp) {
        TemplateContent record = new TemplateContent();
        record.setOrgid(this.getSysUser().getOrgId()); // 后续动态获取
        record.setTpTypeId(tp.getTpTypeId());

        List<TemplateContent> result = this.templateContentService.queryByType(record);
        return R.ok().setData(result);
    }

    @ApiOperation(value = "获取指定模板信息")
    @GetMapping("/template/{tpId}")
    public R get(@PathVariable("tpId") Integer tpId) {
        TemplateContent tc = this.templateContentService.selectByPrimaryKey(tpId);
        return R.ok().setData(tc);
    }

    @ApiOperation(value = "删除模板信息")
    @DeleteMapping("/template/{tpId}")
    public R delete(@PathVariable("tpId") Integer tpId) {
        TemplateContent tc = new TemplateContent();
        tc.setTpId(tpId);
        tc.setOrgid(this.getSysUser().getOrgId());
        int rc = this.templateContentService.delete(tc);
        if (rc > 0) {
            return R.ok();
        } else {
            return R.error("删除失败!");
        }
    }

    @ApiOperation(value = "新增模板信息")
    @PostMapping("/template")
    public R save(@RequestBody TemplateContent tc) {
        ValidatorUtils.validateEntity(tc);
        SysUser sysUser = this.getSysUser();
        tc.setUid(sysUser.getUserId());
        tc.setOrgid(sysUser.getOrgId());
        
        this.templateContentService.insert(tc);
        return R.ok();
    }

    @ApiOperation(value = "更新模板信息")
    @PutMapping("/template")
    public R update(@RequestBody TemplateContent tc) {
        ValidatorUtils.validateEntity(tc);
        tc.setUid(null);
        tc.setOrgid(null);
        this.templateContentService.updateByPrimaryKeySelective(tc);
        return R.ok();
    }

}