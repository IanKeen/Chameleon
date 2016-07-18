//
//  File+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

extension File: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> File {
        return try tryMake(File(
            id:                     try builder.property("id"),
            created:                try builder.property("created"),
            name:                   builder.optionalProperty("name"),
            title:                  try builder.property("title"),
            mimetype:               try builder.property("mimetype"),
            filetype:               try builder.property("filetype"),
            pretty_type:            try builder.property("pretty_type"),
            user:                   try builder.slackModel("user"),
            mode:                   try builder.property("mode"),
            editable:               builder.property("editable"),
            is_external:            builder.property("is_external"),
            is_public:              builder.property("is_public"),
            external_type:          try builder.property("external_type"),
            username:               try builder.property("username"),
            size:                   try builder.property("size"),
            updated:                builder.optionalProperty("updated"),
            editor:                 try builder.optionalSlackModel("editor"),
            last_editor:            try builder.optionalSlackModel("last_editor"),
            state:                  builder.optionalProperty("state"),
            url_private:            try builder.property("url_private"),
            url_private_download:   try builder.property("url_private_download"),
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
            permalink:              try builder.property("permalink"),
            permalink_public:       try builder.property("permalink_public"),
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
            comments_count:         try builder.property("comments_count")
            )
        )
    }
}
