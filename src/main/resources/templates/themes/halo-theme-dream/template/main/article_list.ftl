<#macro article_list posts>
    <#list posts as post>
        <#local thumbnail = (post.thumbnail?? && post.thumbnail!='')?then(post.thumbnail!, (settings.default_thumbnail?? && settings.default_thumbnail!='')?then(settings.default_thumbnail + settings.default_thumbnail?contains('?')?then("&","?") + "postId=" + post.id?c, ''))>
        <#if is_first_index?? && thumbnail != '' && !(post.topPriority!=1 || !post.metas?? || (post.metas.index_carousel!'false')=='false')>
            <#continue>
        </#if>
        <#local thumbnail_mode = ((settings.top_thumbnail_mode!'default')=='grid' || (post.topPriority==0 && (settings.thumbnail_mode!'default')=='grid'))?then(
        'grid', (post.metas?? && (post.metas.thumbnail_mode!'')?trim!='')?then(post.metas.thumbnail_mode?trim, (post.topPriority==1)?then(settings.top_thumbnail_mode!'back', settings.thumbnail_mode!'default')))>
        <#if thumbnail != '' && thumbnail_mode == "back">
            <div class="card widget card-cover">
                <a href="${post.fullPath!}">
                    <div class="cover-image" style="background-image: url(${thumbnail!})">
                    </div>
                    <div class="details">
                        <h2 class="title"><#if post.topPriority==1><span class="top">置顶</span></#if>${post.title!}
                        </h2>
                        <ul class="breadcrumb">
                            <li><@global.timeline datetime=post.createTime/></li>
                            <li><i class="ri-eye-line"></i>${post.visits?c}</li>
                            <#if !post.disallowComment!false>
                                <li><i class="ri-question-answer-line"></i>${post.commentCount?c}</li></#if>
                            <li><i class="ri-thumb-up-line"></i>${post.likes?c}</li>
                            <#local heat= (24+post.visits*0.1+post.likes*2+post.commentCount*3) />
                            <#local heatColor= '#'+(heat < 37)?string('ffa87e',(heat < 120)?string('fb734a','e0081c')) />
                            <li style="color: ${heatColor}">${heat}℃</li>
                        </ul>
                    </div>
                </a>
                <#if post.categories?? && post.categories?size gt 0>
                    <div class="category">
                        <#list post.categories as category>
                            <a href="${category.fullPath!}">${category.name!}</a>
                        </#list>
                    </div>
                </#if>
            </div>
        <#elseif thumbnail != '' && (thumbnail_mode == "small" || (thumbnail_mode == "small-alter" && post_index%2 == 0))>
            <div class="card widget card-small">
                <a href="${post.fullPath!}">
                    <div class="small-image" style="background-image: url(${thumbnail!})"></div>
                </a>
                <div class="card-content main">
                    <h2 class="title">
                        <#if post.topPriority==1><span class="top">置顶</span></#if><a
                                href="${post.fullPath!}">${post.title!}</a>
                    </h2>
                    <div class="main-content">${post.summary!}</div>
                    <hr/>
                    <div class="meta">
                        <ul class="breadcrumb">
                            <li><@global.timeline datetime=post.createTime/></li>
                            <li><i class="ri-eye-line"></i>${post.visits?c}</li>
                            <#if !post.disallowComment!false><li><i class="ri-question-answer-line"></i>${post.commentCount?c}</li></#if>
                            <li><i class="ri-thumb-up-line"></i>${post.likes?c}</li>
                            <#local heat= (24+post.visits*0.1+post.likes*2+post.commentCount*3) />
                            <#local heatColor= '#'+(heat < 37)?string('ffa87e',(heat < 120)?string('fb734a','e0081c')) />
                            <li style="color: ${heatColor}">${heat}℃</li>
                        </ul>
                        <#if post.categories?? && post.categories?size gt 0>
                            <div class="level-item is-hidden-mobile">
                                <#list post.categories as category>
                                    <a href="${category.fullPath!}">${category.name!}</a>&nbsp;
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>
            </div>
        <#elseif thumbnail != '' && (thumbnail_mode == "small-right" || (thumbnail_mode == "small-alter" && post_index%2 == 1))>
            <div class="card widget card-small">
                <div class="card-content main">
                    <h2 class="title">
                        <#if post.topPriority==1><span class="top">置顶</span></#if><a
                                href="${post.fullPath!}">${post.title!}</a>
                    </h2>
                    <div class="main-content">${post.summary!}</div>
                    <hr/>
                    <div class="meta">
                        <ul class="breadcrumb">
                            <li><@global.timeline datetime=post.createTime/></li>
                            <li><i class="ri-eye-line"></i>${post.visits?c}</li>
                            <#if !post.disallowComment!false><li><i class="ri-question-answer-line"></i>${post.commentCount?c}</li></#if>
                            <li><i class="ri-thumb-up-line"></i>${post.likes?c}</li>
                            <#local heat= (24+post.visits*0.1+post.likes*2+post.commentCount*3) />
                            <#local heatColor= '#'+(heat < 37)?string('ffa87e',(heat < 120)?string('fb734a','e0081c')) />
                            <li style="color: ${heatColor}">${heat}℃</li>
                        </ul>
                        <#if post.categories?? && post.categories?size gt 0>
                            <div class="level-item is-hidden-mobile">
                                <#list post.categories as category>
                                    <a href="${category.fullPath!}">${category.name!}</a>&nbsp;
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>
                <a href="${post.fullPath!}"><div class="small-image" style="background-image: url(${thumbnail!})"></div></a>
            </div>
        <#elseif post.topPriority==1 && thumbnail_mode == "fold">
            <a class="card widget card-fold" href="${post.fullPath!}">
                <h2 class="title"><span class="top">置顶</span><p>${post.title!}</p></h2>
                <p><@global.timeline datetime=post.createTime/></p>
            </a>
        <#elseif thumbnail_mode == "grid">
            <div class="column-main-grid">
            <#list post_index..(posts?size-1) as i>
                <#local gradPost=posts[i]>
                <#local thumbnail = (gradPost.thumbnail?? && gradPost.thumbnail!='')?then(gradPost.thumbnail!, (settings.default_thumbnail?? && settings.default_thumbnail!='')?then(settings.default_thumbnail + settings.default_thumbnail?contains('?')?then("&","?") + "postId=" + gradPost.id?c, ''))>
                <#if is_first_index?? && thumbnail != '' && !(gradPost.topPriority!=1 || !gradPost.metas?? || (gradPost.metas.index_carousel!'false')=='false')>
                    <#continue>
                </#if>
                <div class="card widget">
                  <a class="thumbnail" href="${gradPost.fullPath!}">
                    <div class="thumbnail-image" style="background-image: url(${thumbnail!})">
                    </div>
                  </a>
                  <ul class="breadcrumb">
                    <li><@global.timeline datetime=gradPost.createTime/></li>
                    <li><i class="ri-eye-line"></i>${gradPost.visits?c}</li>
                      <#if !gradPost.disallowComment!false><li class="is-hidden-mobile"><i class="ri-question-answer-line"></i>${gradPost.commentCount?c}</li></#if>
                    <li class="is-hidden-mobile"><i class="ri-thumb-up-line"></i>${gradPost.likes?c}</li>
                      <#local heat= (24+gradPost.visits*0.1+gradPost.likes*2+gradPost.commentCount*3) />
                      <#local heatColor= '#'+(heat < 37)?string('ffa87e',(heat < 120)?string('fb734a','e0081c')) />
                    <li style="color: ${heatColor}">${heat}℃</li>
                  </ul>
                  <h2 class="title">
                      <#if gradPost.topPriority==1><span class="top">置顶</span></#if><a
                            href="${gradPost.fullPath!}">${gradPost.title!}</a>
                  </h2>
              </div>
            </#list>
            </div>
            <#break/>
        <#else>
            <div class="card widget">
                <#if thumbnail?? && thumbnail!=''>
                    <a class="thumbnail" href="${post.fullPath!}">
                        <div class="thumbnail-image" style="background-image: url(${thumbnail!})">
                        </div>
                    </a>
                </#if>
                <div class="card-content main">
                    <h2 class="title">
                        <#if post.topPriority==1><span class="top">置顶</span></#if><a
                                href="${post.fullPath!}">${post.title!}</a>
                    </h2>
                    <div class="meta">
                        <ul class="breadcrumb">
                            <li><@global.timeline datetime=post.createTime/></li>
                            <li><i class="ri-eye-line"></i>${post.visits?c}</li>
                            <#if !post.disallowComment!false><li class="is-hidden-mobile"><i class="ri-question-answer-line"></i>${post.commentCount?c}</li></#if>
                            <li class="is-hidden-mobile"><i class="ri-thumb-up-line"></i>${post.likes?c}</li>
                            <#local heat= (24+post.visits*0.1+post.likes*2+post.commentCount*3) />
                            <#local heatColor= '#'+(heat < 37)?string('ffa87e',(heat < 120)?string('fb734a','e0081c')) />
                            <li style="color: ${heatColor}">${heat}℃</li>
                        </ul>
                        <#if post.categories?? && post.categories?size gt 0>
                            <div class="level-item">
                                <#list post.categories as category>
                                    <a href="${category.fullPath!}">${category.name!}</a>&nbsp;
                                </#list>
                            </div>
                        </#if>
                    </div>
                    <hr/>
                    <div class="main-content">${post.summary!}</div>
                </div>
            </div>
        </#if>
    </#list>
</#macro>