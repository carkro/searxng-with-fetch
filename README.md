# SearXNG with Fetch

基于 [SearXNG](https://github.com/searxng/searxng) 的元搜索引擎，在原版功能之上**新增了一个 `/fetch` 端点**：抓取任意 http/https 网页并返回干净的纯文本，方便程序化研究。

搜索功能与原版 SearXNG 完全一致，可作为完整的搜索服务对外提供网络访问。

## 核心增量：/fetch 端点

抓取网页正文，返回前 N 个字符的纯文本（用 `lxml` 解析，规避了原版 `html_to_text` 泄漏闭合标签的 bug）。

```bash
# 抓取 https 页面
curl 'http://<host>:8888/fetch?url=https://docs.searxng.org&limit=3000'

# 抓取 http 页面（通过专用 fetch 网络允许）
curl 'http://<host>:8888/fetch?url=http://example.com&limit=500'
```

返回 JSON：

```json
{"url": "...", "status": 200, "length": 171, "text": "纯文本内容..."}
```

参数：

- `url`（必填）：要抓取的 http/https 地址
- `limit`（可选）：返回的最大字符数，默认 3000，上限 100000

## 相对原版 SearXNG 的改动

| 文件 | 改动 |
|------|------|
| `searxng-src/searx/webapp.py` | 新增 `/fetch` 路由；用 `lxml` 解析 HTML 提取纯文本；通过专用网络 `fetch` 允许抓取 http 页面 |
| `etc/searxng/settings.yml` | 作者调试用配置（见下节） |
| `start.sh` / `stop.sh` | 一键启动 / 停止脚本 |

## 关于随附的 settings.yml（调试配置，非功能限制）

仓库里 `etc/searxng/settings.yml` 是**调试时用的配置**，不代表本项目的功能边界：

- `bind_address: "127.0.0.1"` —— 调试时只监听本机回环地址
- `keep_only: [bing]` + `base_url: cn.bing.com` —— 调试时只启用Bing搜索，正式部署删除即可

**要把它当作完整的搜索服务对外提供，改两处即可：**

1. `bind_address` 改为 `"0.0.0.0"`（监听所有网卡，可被网络访问）
2. 删除 `use_default_settings.engines.keep_only` 整段（恢复全部默认引擎）

改完重启即可。其余引擎能否访问取决于你的网络环境。

## 环境要求

- Python 3.10+
- 已创建虚拟环境 `searxng-venv` 并以 editable 模式安装 SearXNG

## 使用方法

```bash
./start.sh    # 启动，监听地址取决于 settings.yml（调试配置默认 127.0.0.1:8888）
./stop.sh     # 停止
```

日志输出到 `/tmp/searxng-run.log`。

搜索（JSON）：

```bash
curl 'http://<host>:8888/search?q=关键词&format=json'
```

## 原始项目

本项目基于 [SearXNG](https://github.com/searxng/searxng) —— 一个隐私友好的元搜索引擎（metasearch engine），聚合多个搜索引擎的结果，不追踪用户。

- 官网 / 文档：https://docs.searxng.org
- GitHub：https://github.com/searxng/searxng
- 许可证：AGPL-3.0

## 许可证

本项目遵循与原项目相同的 [AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.txt) 许可证。所有对 SearXNG 的修改同样以 AGPL-3.0 发布。详见 `LICENSE` 文件。