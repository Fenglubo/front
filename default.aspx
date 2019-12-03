<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="mainpart">
        <input type="button" onclick="draw_point('001', 200, 300)" value="加载栅格地图" />
        <input type="button" onclick="getmyXML()" value="加载XML地图" />
        <asp:Button runat="server" OnClick="loadmyxmlmap" ID="loadmyxml" Text="asp加载地图" />
        <input type="button" id="editstatus" onclick="changeeditstatus()" value="进入编辑模式" />
        <!--因安全性限制，浏览器无法获取本地文件路径，由服务器传递文件-->
        <!--绘制地图-->
        <canvas id="mc" width="1600" height="750" style="border: 1px solid black">drawGrid('#09f', 10, 10);
        </canvas>
        <!--显示鼠标当前坐标-->
        <div id="locationlabel"
            style="border-block-color: #000000; border-width: 1px; width: 800; height: 30; font-size: 10pt;">
            x=0;Y=0;
        </div>
    </div>
    <script type="text/javascript">
        //读取canvas
        var canvas = document.getElementById('mc');
        var context = canvas.getContext('2d');
        //更改编辑状态
        function changeeditstatus(){
            var editstatus = document.getElementById('editstatus');
            if (editstatus.getAttribute('value') == '进入编辑模式') {
                editstatus.value='退出编辑模式';
            }
            else{
                editstatus.value = '进入编辑模式';
            }
        }
        //canvas鼠标点击事件
        canvas.onmouse 
        //绘制点与点名
        function draw_point(name, x, y) {
            context.beginPath();
            context.fillStyle = 'black';
            context.arc(x, y, 6, 0, 2 * Math.PI);
            context.fill();
            //填入点名
            context.font = '9pt Arial';
            context.fillText(name, x + 7, y + 5);
        }
        //加载XML地图
        function getmyXML() {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    alert('ok');
                    xmltest(this);
                }
            };
            xhttp.open("GET", "App_Data/test.xml", true);
            xhttp.send();
            //$.ajax({
            //    url: './App_Data/blessme.xml',
            //    type: 'GET',
            //    dataType: 'xml',
            //    timeout: 1000,  //设定超时
            //    cache: false,   //禁用缓存
            //    success: function (xml) {
            //        alert("加载成功!");
            //    }
            //    //success: Getxmlvalueattr   //设置成功后回调函数
            //});
        }
        function xmltest(xml) {
            var xmlDoc = xml.responseXML;
            alert('test');
        }
        function Getxmlvalueattr(xml) {
            var pointname = 0;
            var xposition = 0;
            var yposition = 0;
            var locationlabel = document.getElementById('locationlabel');
            alert('加载中');
            $(xml).find("point").each(function (i) {     //查找所有point节点并遍历
                //var id = $(this).children("id");          //获得子节点
                //var id_vaule = id.text();                 //获取节点文本
                pointname = $(this).attr("name");  //获取节点的属性
                xposition = $(this).attr("xposition");
                yposition = $(this).attr("yposition");
                locationlabel.innerHTML = 'test' + pointname;
                //draw_point(pointname, xposition, yposition);
            });
            var sourcepoint = 0;
            var destinationPoint = 0;
            $(xml).find("path").each(function (i) {     //查找所有path节点并遍历
                //var id = $(this).children("id");          //获得子节点
                //var id_vaule = id.text();                 //获取节点文本
                sourcepoint = $(this).attr("sourcepoint");  //获取节点的属性
                $(xml).find("point").each(function (i) {     //查找所有point节点并遍历
                    if ($(this).attr('sourcepoint') == sourcepoint) {
                        xposition = $(this).attr("xposition");
                        yposition = $(this).attr("yposition");
                        return false;
                    }
                });
                destinationPoint = $(this).attr("destinationPoint");
                $(xml).find("point").each(function (i) {     //查找所有point节点并遍历
                    if ($(this).attr('destinationPoint') == destinationPoint) {
                        drawLine(xposition, yposition, $(this).attr("xposition"), yposition = $(this).attr("yposition"));
                        return false;
                    }
                });
            });
        }
        //var xmlDoc = new ActiveXObject('Msxml2.DOMDocument');
        //xmlDoc.loadXML(XMLfile);
        //var xmlDoc = getxmlDoc("test.xml");
        //var nodeList = xmlDoc.documentElement.getElementByTagName('point');
        //var nodeList = xmlDoc.document.getelementbytagname('point');
        //locationlabel.innerHTML =check[1].getattribute('yPosition');
        //var xposition = 0;
        //var yposition = 0;
        //var pointname = 0;
        //for (var i = 0; i < nodeList.length; i++) {
        //    pointname = nodeList[i].getattribute('name');
        //    xposition = nodeList[i].getattribute('xPosition');
        //    yposition = nodeList[i].getattribute('yPosition');
        //    draw_point(pointname, xposition, yposition);
        //}


        ////IE
        //if (navigator.userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
        //    //遍历point节点
        //    var nodeList = xmlDoc.documentElement.getElementsByTagName("point");
        //    for (var i = 0; i < nodeList.length; i++) {
        //        //
        //    }
        ////非IE
        //else {
        //        var nodeList = xmlDoc.getElementsByTagName("area");
        //        for (var i = 0; i < nodeList.length; i++) {
        //            //...遍历操作...
        //        }
        //    }
        //}


        //绘制直线（含起终点坐标）
        function drawLine(x1, y1, x2, y2) {
            context.moveTo(x1, y1);
            context.lineTo(x2, y2);
            context.stroke();
        }

        //鼠标坐标追踪
        canvas.onmousemove = function (e) {
            var location = getLocation(e.clientX, e.clientY);
            var locationlabel = document.getElementById('locationlabel');
            locationlabel.innerHTML = "x=" + parseInt(location.x) + " ,y=" + parseInt(location.y);//显示取整后坐标
        };
        //获取坐标
        function getLocation(x, y) {
            var bbox = canvas.getBoundingClientRect();
            return {
                x: (x - bbox.left) * (canvas.width / bbox.width) - 50,
                y: (y - bbox.top) * (canvas.height / bbox.height) - 30
            };
        }
        //页面加载事件
        window.onload = function () {
            var canvas = document.getElementById('mc');
            //异常处理
            if (!canvas.getContext) {
                alert('当前浏览器不支持canvas,请更新到IE9及以上版本');
                return;
            }
            context.translate(50, 30);
            drawAxis(context);
            //绘制网格的方法
            function drawAxis(cxt) {
                var dx = 0,
                    dy = 50,
                    x = 0,
                    y = 0,
                    w = canvas.width,
                    h = canvas.height;
                cxt.lineWidth = 1;
                cxt.strokeStyle = "silver";
                var textX = 50;
                var textY = 0;
                //绘制y轴
                for (var i = 0; i <= w - 50; i += 10) {
                    drawLine(i, 0, i, h);
                }
                //绘制数字
                while (dx < w) {
                    cxt.font = '9pt Arial';
                    cxt.fillStyle = 'black';
                    cxt.fillText(textY, dx, -5);
                    textY += 50;
                    dx += 50;
                }
                //绘制x轴
                i = 0;
                while (i <= h) {
                    drawLine(0, i, w, i);
                    i += 10;
                }
                //绘制数字
                while (dy < h) {
                    cxt.font = '9pt Arial';
                    cxt.fillStyle = 'black';
                    cxt.fillText(textX, -30, dy);
                    textX += 50;
                    dy += 50;
                }
            }
        };
    </script>

</asp:Content>
