defmodule JequalSONSpec do
  use ESpec

  @twitter_response ~S"""
{
  "statuses": [
    {
      "coordinates": null,
      "favorited": false,
      "truncated": false,
      "created_at": "Mon Sep 24 03:35:21 +0000 2012",
      "id_str": "250075927172759552",
      "entities": {
        "urls": [

        ],
        "hashtags": [
          {
            "text": "freebandnames",
            "indices": [
              20,
              34
            ]
          }
        ],
        "user_mentions": [

        ]
      },
      "in_reply_to_user_id_str": null,
      "contributors": null,
      "text": "Aggressive Ponytail #freebandnames",
      "metadata": {
        "iso_language_code": "en",
        "result_type": "recent"
      },
      "retweet_count": 0,
      "in_reply_to_status_id_str": null,
      "id": 250075927172759552,
      "geo": null,
      "retweeted": false,
      "in_reply_to_user_id": null,
      "place": null,
      "user": {
        "profile_sidebar_fill_color": "DDEEF6",
        "profile_sidebar_border_color": "C0DEED",
        "profile_background_tile": false,
        "name": "Sean Cummings",
        "profile_image_url": "http://a0.twimg.com/profile_images/2359746665/1v6zfgqo8g0d3mk7ii5s_normal.jpeg",
        "created_at": "Mon Apr 26 06:01:55 +0000 2010",
        "location": "LA, CA",
        "follow_request_sent": null,
        "profile_link_color": "0084B4",
        "is_translator": false,
        "id_str": "137238150",
        "entities": {
          "url": {
            "urls": [
              {
                "expanded_url": null,
                "url": "",
                "indices": [
                  0,
                  0
                ]
              }
            ]
          },
          "description": {
            "urls": [

            ]
          }
        },
        "default_profile": true,
        "contributors_enabled": false,
        "favourites_count": 0,
        "url": null,
        "profile_image_url_https": "https://si0.twimg.com/profile_images/2359746665/1v6zfgqo8g0d3mk7ii5s_normal.jpeg",
        "utc_offset": -28800,
        "id": 137238150,
        "profile_use_background_image": true,
        "listed_count": 2,
        "profile_text_color": "333333",
        "lang": "en",
        "followers_count": 70,
        "protected": false,
        "notifications": null,
        "profile_background_image_url_https": "https://si0.twimg.com/images/themes/theme1/bg.png",
        "profile_background_color": "C0DEED",
        "verified": false,
        "geo_enabled": true,
        "time_zone": "Pacific Time (US & Canada)",
        "description": "Born 330 Live 310",
        "default_profile_image": false,
        "profile_background_image_url": "http://a0.twimg.com/images/themes/theme1/bg.png",
        "statuses_count": 579,
        "friends_count": 110,
        "following": null,
        "show_all_inline_media": false,
        "screen_name": "sean_cummings"
      },
      "in_reply_to_screen_name": null,
      "source": "<a>Twitter for Mac</a>",
      "in_reply_to_status_id": null
    },
    {
      "coordinates": null,
      "favorited": false,
      "truncated": false,
      "created_at": "Fri Sep 21 23:40:54 +0000 2012",
      "id_str": "249292149810667520",
      "entities": {
        "urls": [

        ],
        "hashtags": [
          {
            "text": "FreeBandNames",
            "indices": [
              20,
              34
            ]
          }
        ],
        "user_mentions": [

        ]
      },
      "in_reply_to_user_id_str": null,
      "contributors": null,
      "text": "Thee Namaste Nerdz. #FreeBandNames",
      "metadata": {
        "iso_language_code": "pl",
        "result_type": "recent"
      },
      "retweet_count": 0,
      "in_reply_to_status_id_str": null,
      "id": 249292149810667520,
      "geo": null,
      "retweeted": false,
      "in_reply_to_user_id": null,
      "place": null,
      "user": {
        "profile_sidebar_fill_color": "DDFFCC",
        "profile_sidebar_border_color": "BDDCAD",
        "profile_background_tile": true,
        "name": "Chaz Martenstein",
        "profile_image_url": "http://a0.twimg.com/profile_images/447958234/Lichtenstein_normal.jpg",
        "created_at": "Tue Apr 07 19:05:07 +0000 2009",
        "location": "Durham, NC",
        "follow_request_sent": null,
        "profile_link_color": "0084B4",
        "is_translator": false,
        "id_str": "29516238",
        "entities": {
          "url": {
            "urls": [
              {
                "expanded_url": null,
                "url": "http://bullcityrecords.com/wnng/",
                "indices": [
                  0,
                  32
                ]
              }
            ]
          },
          "description": {
            "urls": [

            ]
          }
        },
        "default_profile": false,
        "contributors_enabled": false,
        "favourites_count": 8,
        "url": "http://bullcityrecords.com/wnng/",
        "profile_image_url_https": "https://si0.twimg.com/profile_images/447958234/Lichtenstein_normal.jpg",
        "utc_offset": -18000,
        "id": 29516238,
        "profile_use_background_image": true,
        "listed_count": 118,
        "profile_text_color": "333333",
        "lang": "en",
        "followers_count": 2052,
        "protected": false,
        "notifications": null,
        "profile_background_image_url_https": "https://si0.twimg.com/profile_background_images/9423277/background_tile.bmp",
        "profile_background_color": "9AE4E8",
        "verified": false,
        "geo_enabled": false,
        "time_zone": "Eastern Time (US & Canada)",
        "description": "You will come to Durham, North Carolina. I will sell you some records then, here in Durham, North Carolina. Fun will happen.",
        "default_profile_image": false,
        "profile_background_image_url": "http://a0.twimg.com/profile_background_images/9423277/background_tile.bmp",
        "statuses_count": 7579,
        "friends_count": 348,
        "following": null,
        "show_all_inline_media": true,
        "screen_name": "bullcityrecords"
      },
      "in_reply_to_screen_name": null,
      "source": "web",
      "in_reply_to_status_id": null
    }
  ]
}
  """
@parsed_json Poison.Parser.parse!(@twitter_response)

  describe ".match?/2" do
    context "succesful schema" do
      let :schema, do: %{
        statuses: [%{
          id_str: :string,
          favorited: :boolean
        }]
      }

      it do: expect(
        JequalSON.match?(@parsed_json, schema)
      ).to be_true
    end

    context "unsucceesful schema" do
      let :schema, do: %{
        statuses: :object
      }

      it "returns failure message" do
        { :failure, message } = JequalSON.match?(@parsed_json, schema)
        expect(message).to match "to be a 'Object' type"
      end
    end
  end

  describe ".match?/3" do
    context "nested path, any item in an array must match type schema" do
      let :path, do: "statuses[?].entities"
      let :schema, do: %{
        urls: :array,
        hashtags: [%{
          text: :string,
          indices: :array
        }]
      }

      it do: expect(
        JequalSON.match?(@parsed_json, path, schema)
      ).to be_true
    end

    context "nested path, first item in an array must match combined schema" do
      let :hex_color do
        fn(v)->
          Regex.match?(~r/^[A-F0-9]{6}$/, v)
            or {:failure, "#{v} is not a color"}
        end
      end
      let :path, do: "statuses[0].user"
      let :schema, do: %{
        name: "Sean Cummings",
        id_str: :string,
        entities: %{
          url: :object
        },
        profile_background_color: hex_color
      }

      it do: expect(
        JequalSON.match?(@parsed_json, path, schema)
      ).to be_true
    end

    context "nested path, all items in an array must match combined schema" do
      let :path, do: "statuses[*]"
      let :schema, do: %{
        id: :integer,
        text: :string,
        user: :object,
        retweet_count: 0,
        favorited: :boolean,
        metadata: %{
          iso_language_code: "en"
        },
      }

      it do: expect(
        JequalSON.match?(@parsed_json, path, schema)
      ).to be_true
    end
  end
end
