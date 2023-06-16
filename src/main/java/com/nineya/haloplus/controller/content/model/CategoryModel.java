package com.nineya.haloplus.controller.content.model;

import static org.springframework.data.domain.Sort.Direction.DESC;

import com.google.common.collect.Sets;
import java.util.Set;

import com.nineya.haloplus.model.dto.CategoryDTO;
import com.nineya.haloplus.model.entity.Category;
import com.nineya.haloplus.model.entity.Post;
import com.nineya.haloplus.model.enums.EncryptTypeEnum;
import com.nineya.haloplus.model.enums.PostStatus;
import com.nineya.haloplus.model.support.HaloConst;
import com.nineya.haloplus.model.vo.PostListVO;
import com.nineya.haloplus.service.CategoryService;
import com.nineya.haloplus.service.OptionService;
import com.nineya.haloplus.service.PostCategoryService;
import com.nineya.haloplus.service.ThemeService;
import com.nineya.haloplus.service.assembler.PostRenderAssembler;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;
import com.nineya.haloplus.controller.content.auth.CategoryAuthentication;

/**
 * Category Model.
 *
 * @author ryanwang
 * @author guqing
 * @date 2020-01-11
 */
@Component
public class CategoryModel {

    private final CategoryService categoryService;

    private final ThemeService themeService;

    private final PostCategoryService postCategoryService;

    private final PostRenderAssembler postRenderAssembler;

    private final OptionService optionService;

    private final CategoryAuthentication categoryAuthentication;

    public CategoryModel(CategoryService categoryService,
        ThemeService themeService,
        PostCategoryService postCategoryService,
        PostRenderAssembler postRenderAssembler, OptionService optionService,
        CategoryAuthentication categoryAuthentication) {
        this.categoryService = categoryService;
        this.themeService = themeService;
        this.postCategoryService = postCategoryService;
        this.postRenderAssembler = postRenderAssembler;
        this.optionService = optionService;
        this.categoryAuthentication = categoryAuthentication;
    }

    /**
     * List categories.
     *
     * @param model model
     * @return template name
     */
    public String list(Model model) {
        model.addAttribute("is_categories", true);
        model.addAttribute("meta_keywords", optionService.getSeoKeywords());
        model.addAttribute("meta_description", optionService.getSeoDescription());
        return themeService.render("categories");
    }

    /**
     * List category posts.
     *
     * @param model model
     * @param slug slug
     * @param page current page
     * @return template name
     */
    public String listPost(Model model, String slug, Integer page) {

        // Get category by slug
        final Category category = categoryService.getBySlugOfNonNull(slug);

        if (!categoryAuthentication.isAuthenticated(category.getId())) {
            model.addAttribute("slug", category.getSlug());
            model.addAttribute("type", EncryptTypeEnum.CATEGORY.getName());
            if (themeService.templateExists(
                HaloConst.POST_PASSWORD_TEMPLATE + HaloConst.SUFFIX_FTL)) {
                return themeService.render(HaloConst.POST_PASSWORD_TEMPLATE);
            }
            return "common/template/" + HaloConst.POST_PASSWORD_TEMPLATE;
        }

        Set<PostStatus> statuses = Sets.immutableEnumSet(PostStatus.PUBLISHED);
        if (categoryService.isPrivate(category.getId())) {
            statuses = Sets.immutableEnumSet(PostStatus.INTIMATE);
        }

        CategoryDTO categoryDTO = categoryService.convertTo(category);

        final Pageable pageable = PageRequest.of(page - 1,
            optionService.getArchivesPageSize(),
            Sort.by(DESC, "topPriority", "createTime"));
        Page<Post> postPage =
            postCategoryService.pagePostBy(category.getId(), statuses, pageable);
        Page<PostListVO> posts = postRenderAssembler.convertToListVo(postPage);

        // Generate meta description.
        if (StringUtils.isNotEmpty(category.getDescription())) {
            model.addAttribute("meta_description", category.getDescription());
        } else {
            model.addAttribute("meta_description", optionService.getSeoDescription());
        }

        model.addAttribute("is_category", true);
        model.addAttribute("posts", posts);
        model.addAttribute("category", categoryDTO);
        model.addAttribute("meta_keywords", optionService.getSeoKeywords());
        return themeService.render("category");
    }
}
