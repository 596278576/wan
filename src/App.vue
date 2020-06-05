<template>
  <div class="netHall">
    <div class="form">
      <van-form @submit="onSubmit" validate-first :show-error-message="false" scroll-to-error>
        <div class="selectTitle">
          <van-cell-group :border="false" title="宽带套餐">
            <van-icon name="star" />
            <van-field name="radio" class="select">
              <template #input>
                <van-radio-group v-model="userInfoList.package" direction="horizontal">
                  <van-radio
                    checked-color="#07c160"
                    icon-size="20px"
                    name="【联通包月】 200M宽带 99/月"
                  >【联通包月】 200M宽带 99/月</van-radio>
                  <van-radio
                    checked-color="#07c160"
                    icon-size="20px"
                    name="【联通包年】 200M宽带 79/月"
                  >【联通包年】 200M宽带 79/月</van-radio>
                  <van-radio
                    checked-color="#07c160"
                    icon-size="20px"
                    name="【联通包两年】 200M宽带 69/月"
                  >【联通包两年】 200M宽带 69/月</van-radio>
                  <van-radio
                    checked-color="#07c160"
                    icon-size="20px"
                    name="【珠江宽频】 100M宽带 99/月"
                  >【珠江宽频】 100M宽带 99/月</van-radio>
                  <van-radio
                    checked-color="#07c160"
                    icon-size="20px"
                    name="【移动宽带】 移动用户 免费领取"
                  >【移动宽带】 移动用户 免费领取</van-radio>
                </van-radio-group>
              </template>
            </van-field>
          </van-cell-group>
        </div>

        <van-cell-group :border="false" title="姓名" class="name">
          <van-icon name="star" />
          <van-field
            v-model="userInfoList.name"
            ref="receiverName"
            @blur="receiverName"
            placeholder="请输入姓名"
            :rules="[{ required: true, message: '请输入姓名' }]"
          />
        </van-cell-group>
        <van-cell-group :border="false" title="联系电话" class="mobile">
          <van-icon name="star" />
          <van-field
            v-model="userInfoList.mobile"
            ref="receiverName"
            @blur="receiverName"
            placeholder="请输入联系电话"
            :rules="[{ required: true, message: '请输入联系电话' }]"
          />
        </van-cell-group>

        <van-cell-group :border="false" title="安装地址">
          <!-- 选择地区 -->
          <div class="region" @click="showPopup1">
            <div class="lef" v-if="userInfoList.province==''">地区选择</div>
            <div
              class="lef left"
              v-else
            >{{userInfoList.province +'-'+ userInfoList.city +'-'+ userInfoList.region}}</div>
            <div class="right">
              <van-icon name="arrow" />
            </div>
          </div>
          <van-popup v-model="showPopup" position="bottom">
            <van-area
              :area-list="areaList"
              value="440100"
              @confirm="handleEnter"
              @cancel="handleCancel"
            />
          </van-popup>
          <van-field
            v-model="userInfoList.address"
            ref="receiverName"
            @blur="receiverName"
            placeholder="请输入详细地址"
          />
        </van-cell-group>
        <van-cell-group :border="false" title="身份证号">
          <van-field
            v-model="userInfoList.idcard"
            ref="receiverName"
            @blur="receiverName"
            placeholder="请输入身份证号"
          />
        </van-cell-group>
        <van-cell-group :border="false" title="备注留言">
          <van-field
            class="other"
            v-model="userInfoList.other"
            rows="1"
            autosize
            type="textarea"
            placeholder="可留下QQ或微信号"
          />
        </van-cell-group>
        <div style="margin: 16px;">
          <van-button round block type="info" native-type="submit">提交</van-button>
        </div>
      </van-form>
    </div>
  </div>
</template>

<script>
import wx from "weixin-js-sdk";
import region from "@/assets/region.js";
export default {
  data() {
    return {
      userInfoList: {
        name: "",
        mobile: "",
        address: "",
        idcard: "",
        other: "",
        package: "",
        type: "wan",
        province: "",
        city: "",
        region: ""
      },
      showPopup: false,
      areaList: region
    };
  },
  methods: {
    //点击省市选择确定触发
    handleEnter(val) {
      this.userInfoList.province = val[0].name;
      this.userInfoList.city = val[1].name;
      this.userInfoList.region = val[2].name;
      val;
      this.showPopup = false;
    },
    //点击取消时触发
    handleCancel() {
      this.showPopup = false;
    },

    showPopup1() {
      this.showPopup = true;
    },

    receiverName() {},
    onSubmit() {
      if (this.userInfoList.package == "") {
        this.$toast.fail("请选择套餐");
      } else {
        // console.log(this.userInfoList);
        this.$axios({
          url: "http://form-api.icoeus.cn/",
          method: "post",
          data: this.userInfoList
        })
          .then(res => {
            // console.log(res);
            res;
            this.$toast.success("提交成功");
          })
          .catch(error => {
            error;
            this.$toast.fail("提交失败");
          });
      }
    }
  },
  mounted() {
    this.$axios({
      url:
        "http://dist-front-api.icoeus.cn/oauth/token?grant_type=wx_code&code=02U9HlxwZ4-9",
      headers: {
        Authorization: "Basic ZGVmYXVsdC1jbGllbnQ6ZGVmYXVsdA=="
      },
      method: "POST"
    }).then(res => {
      console.log(res);
      this.$axios({
        url:
          "http://dist-front-api.icoeus.cn/api/front/wx/config?url=" +
          location.href,
        headers: {
          Authorization: "Bearer " + res.data.access_token
        }
      }).then(res => {
        wx.config(res.data);

        wx.ready(function() {
          //分享给朋友
          wx.onMenuShareAppMessage({
            title: "宽带开户", // 分享标题
            desc: "宽带预约,宽带开户", // 分享描述
            link: location.href, // 分享链接
            imgUrl:
              "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=140145420,3500898214&fm=26&gp=0.jpg", // 分享图标
            type: "link", // 分享类型,music、video或link，不填默认为link
            success: function() {
              // 用户确认分享后执行的回调函数
            },
            cancel: function() {
              // 用户取消分享后执行的回调函数
            }
          });
          wx.onMenuShareTimeline({
            title: "地摊创投合作调查！", // 分享标题
            link: location.href, // 分享链接
            imgUrl: "http://form.icoeus.cn/1.jpg", // 分享图标
            success: function() {
              // 用户确认分享后执行的回调函数
            },
            cancel: function() {
              // 用户取消分享后执行的回调函数
            }
          });
        });
        wx.error(function(res) {
          console.info(res);
        });
      });
    });
  }
};
</script>

<style lang="less" scoped>
.region {
  box-sizing: border-box;
  width: 90%;
  margin: 0 auto;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 16px;
  background: #fff;
  margin-bottom: 10px;
  padding: 0 10px;

  .right {
    font-size: 16px !important;
    display: flex;
    align-items: center;
    i {
      font-size: 16px;
      margin-left: 10px;
    }
  }
  .lef {
    color: #ccc;
    font-size: 16px;
  }
  .left {
    color: #000 !important;
  }
}

.other.van-cell {
  height: inherit !important;
}
/deep/ .van-radio--horizontal {
  margin-right: 0;
  font-size: 18px;
}
.netHall {
  max-width: 750px;
  margin: 0 auto;
  background: #d1e3ff;
  padding: 10px;
  .select.van-cell {
    overflow-y: auto;
    height: 180px !important;
    background: #f1f6ff;
    font-size: 15px !important;
    width: 100% !important;
    margin-left: 0 !important;
    padding: 0 20px !important;
  }
  .form {
    background: #f1f6ff;
    // padding: 10px;
    .van-form {
      padding-bottom: 20px;
      /deep/.van-cell {
        // border-bottom: 1px solid #eee;
        height: 40px;
        line-height: 40px;
        padding: 0 10px;
        width: 100%;
        // margin-left: 10px;
        width: 90%;
        margin: 0 auto;
      }
      /deep/.van-cell__right-icon {
        // width: 20px;
        margin-left: 10px;
        margin-top: 0.493333rem;
        font-size: 30px !important;
      }
    }
    // 分类标题
    /deep/.van-cell__title {
      width: 200px;
    }
    /deep/.van-cell__title,
    /deep/.van-cell__value {
      font-size: 16px;
      // height: 100px;
      font-family: PingFang SC;
      font-weight: 400;
      color: rgb(54, 36, 36);
      // line-height: 100px;
    }
    .van-cell-group__title {
      margin-top: 15px;
      font-size: 18px;
      font-family: PingFang SC;
      padding: 0 20px;
      font-weight: 400;
      height: 50px;
      color: rgba(119, 119, 119, 1);
      line-height: 50px;
    }
    /deep/.van-cell-group {
      background: #f1f6ff;
      // width: 90%;
    }
    /deep/.van-cell--required::before {
      right: -18px;
      left: auto;
      font-size: 34px;
    }
    // 提交表单按钮
    /deep/.van-button--block {
      margin-top: 30px;

      width: 100%;
      height: 50px;
      /deep/.van-button__text {
        font-size: 20px;
      }
    }
  }
}
.name {
  position: relative;
  /deep/ .van-icon-star {
    position: absolute;
    z-index: 100;
    // right: 100px;
    left: 60px;
    top: -30px;
    color: #ff0000;
    font-size: 10px;
  }
}
.mobile {
  position: relative;
  /deep/ .van-icon-star {
    position: absolute;
    z-index: 100;
    // right: 100px;
    left: 96px;
    top: -30px;
    color: #ff0000;
    font-size: 10px;
  }
}
.selectTitle {
  position: relative;
  /deep/ .van-icon-star {
    position: absolute;
    z-index: 100;
    // right: 100px;
    left: 96px;
    top: 20px;
    color: #ff0000;
    font-size: 10px;
  }
  /deep/.van-cell-group__title {
    margin-top: 0 !important;
  }
  /deep/ .van-radio {
    margin-top: 20px !important;
    &:nth-child(1) {
      margin-top: 0 !important;
    }
  }
  /deep/.van-cell-group {
    width: 100% !important;
  }
}
</style>