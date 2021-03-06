package com.zltel.broadcast.common.pager;

import com.github.pagehelper.PageRowBounds;

/**
 * 拓展 PageRowBounds ,支持页码分页
 * 
 * @author wangch
 *
 */
public class Pager extends PageRowBounds {
    /** 当前页码 **/
    private int pageIndex;
    /** 默认最大值分页 **/
    public static final Pager DEFAULT_PAGER = new Pager(1, Integer.MAX_VALUE);
    /** 限定一条记录 **/
    public static final Pager ONE_RECORD = new Pager(1, 1);
    /** 不需要记录返回 **/
    public static final Pager NONE_RECORD = new Pager(1, 0);

    /**
     * 创建分页对象
     * 
     * @param pageIndex 页码
     * @param limit 限制条数
     */
    public Pager(int pageIndex, int limit) {
        super(pageOfoffset(pageIndex, limit), limit);
        this.pageIndex = pageIndex;
    }

    private static int pageOfoffset(int pi, int limit) {
        int r = (pi - 1) * limit;
        return r < 0 ? 0 : r;
    }

    /**
     * 当前页码数
     * 
     * @return
     */
    public int getPageIndex() {
        return pageIndex;
    }



}
