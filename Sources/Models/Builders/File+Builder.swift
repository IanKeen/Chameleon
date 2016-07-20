//
//  File+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

extension File: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> File {
        return try tryMake(File(
            id:                     try builder.property("id"),
            created:                builder.optionalProperty("created"),
            name:                   builder.optionalProperty("name"),
            title:                  builder.optionalProperty("title"),
            mimetype:               builder.optionalProperty("mimetype"),
            filetype:               builder.optionalProperty("filetype"),
            pretty_type:            builder.optionalProperty("pretty_type"),
            user:                   try builder.optionalSlackModel("user"),
            mode:                   try builder.optionalProperty("mode"),
            editable:               builder.property("editable"),
            is_external:            builder.property("is_external"),
            is_public:              builder.property("is_public"),
            external_type:          builder.optionalProperty("external_type"),
            username:               builder.optionalProperty("username"),
            size:                   builder.optionalProperty("size"),
            updated:                builder.optionalProperty("updated"),
            editor:                 try builder.optionalSlackModel("editor"),
            last_editor:            try builder.optionalSlackModel("last_editor"),
            state:                  builder.optionalProperty("state"),
            url_private:            builder.optionalProperty("url_private"),
            url_private_download:   builder.optionalProperty("url_private_download"),
            thumb_64:               builder.optionalProperty("thumb_64"),
            thumb_80:               builder.optionalProperty("thumb_80"),
            thumb_360:              builder.optionalProperty("thumb_360"),
            thumb_360_gif:          builder.optionalProperty("thumb_360_gif"),
            thumb_360_w:            builder.optionalProperty("thumb_360_w"),
            thumb_360_h:            builder.optionalProperty("thumb_360_h"),
            thumb_480:              builder.optionalProperty("thumb_480"),
            thumb_480_w:            builder.optionalProperty("thumb_480_w"),
            thumb_480_h:            builder.optionalProperty("thumb_480_h"),
            thumb_160:              builder.optionalProperty("thumb_160"),
            permalink:              builder.optionalProperty("permalink"),
            permalink_public:       builder.optionalProperty("permalink_public"),
            edit_link:              builder.optionalProperty("edit_link"),
            preview:                builder.optionalProperty("preview"),
            preview_highlight:      builder.optionalProperty("preview_highlight"),
            lines:                  builder.optionalProperty("lines"),
            lines_more:             builder.optionalProperty("lines_more"),
            public_url_shared:      builder.property("public_url_shared"),
            display_as_bot:         builder.property("display_as_bot"),
            channels:               try builder.slackModels("channels"),
            groups:                 try builder.slackModels("groups"),
            ims:                    try builder.slackModels("ims"),
            initial_comment:        builder.optionalProperty("initial_comment"),
            num_stars:              builder.optionalProperty("num_stars"),
            is_starred:             builder.optionalProperty("is_starred"),
            pinned_to:              try builder.optionalSlackModels("pinned_to"),
            reactions:              try builder.optionalCollection("reactions"),
            comments_count:         builder.optionalProperty("comments_count")
            )
        )
    }
}
