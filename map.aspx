<%@ Page Language="C#" AutoEventWireup="true" CodeFile="map.aspx.cs" Inherits="html_map" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../js/map.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-3.4.1.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="mainpart">
        <div id="tools">
            <asp:Button ID="Button1" runat="server" Text="ASP方法加载" OnClick="Button1_Click" />
            <input type="button" onclick="draw_point('001', 200, 300, context2)" value="加载栅格地图" />
        <input type="button" onclick="drawmap()" value="加载XML地图" />
        </div>
        <!--因安全性限制，浏览器无法获取本地文件路径，由服务器传递文件-->
        <div id="sidebar" style="float:left;width:100px;height:auto">
            <asp:ListBox ID="ListBox1" runat="server" OnSelectedIndexChanged="ListBox1_SelectedIndexChanged"></asp:ListBox>
        </div>
        <!--绘制地图-->
        <div style="float:left; position: relative;width:1500px;height:750px;">
            <!--第一层canvas，绘制网格及坐标-->
            <canvas id="canvas1" width="1500" height="750" style="top: 0px; position: absolute; border: 1px solid black"></canvas>
            <!--第二层canvas，绘制point及line，station-->
            <canvas id="canvas2" width="1500" height="750" style="top: 0px; position: absolute; border: 1px solid black"></canvas>
            <!--第三层canvas，绘制AGV-->
            <canvas id="canvas3" width="1500" height="750" style="top: 0px; position: absolute; border: 1px solid black"></canvas>
            <!--第四层canvas，检测鼠标动作及绘制高亮点-->
            <canvas id="canvas4" width="1500" height="750" onmousemove="canvasmousemove(event)" onmouseup="canvasmouseup(event)" style="top: 0px; position: absolute; border: 1px solid black"></canvas>
            <!--显示鼠标当前坐标-->
            <div id="locationlabel" style="user-select: none; border-block-color: #000000; background-color: white; position: absolute; border-width: 1px; font-size: 8pt;"></div>
            <div id="infolabel" style="white-space: pre; display: none; background-color: cornsilk; position: absolute; font-size: 10pt;"></div>
        </div>
    </div>
    </form>
</body>
</html>
