<%@ Page Language="C#" AutoEventWireup="true" CodeFile="map.aspx.cs" Inherits="html_map" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../Scripts/jquery-3.4.1.js"></script>
</head>
<body>
    <div id="mainpart">
        <input type="button" onclick="draw_point('001', 200, 300,context2)" value="加载栅格地图" />
        <input type="button" onclick="drawmap()" value="加载XML地图" />
        <input type="button" id="editstatus" onclick="changeeditstatus()" value="进入查看模式" />
        <!--因安全性限制，浏览器无法获取本地文件路径，由服务器传递文件-->
        <!--绘制地图-->
            <div style="position: relative;">
                <canvas id="mc" width="1600" height="750" style="top: 0px; position: absolute; border: 1px solid black">drawGrid('#09f', 10, 10);
                </canvas>
                <canvas id="mc2" width="1600" height="750" style="top: 0px; position: absolute; border: 1px solid black">drawGrid('#09f', 10, 10);
                </canvas>
            </div>
        <!--显示鼠标当前坐标-->
        <div id="locationlabel"
            style="border-block-color: #000000;position:relative; border-width: 1px; width: 800px; height: 30px; font-size: 10pt;">
            x=0;Y=0;
        </div>
    </div>


    <!--JS代码开始-->
    <script type="text/javascript">
        //读取canvas
        var canvas1 = document.getElementById('mc');
        var context1 = canvas1.getContext('2d');
        var canvas2 = document.getElementById('mc2');
        var context2 = canvas2.getContext('2d');
        //更改编辑状态
        function changeeditstatus() {
            var editstatus = document.getElementById('editstatus');
            if (iseditstatus()) {
                editstatus.value = '进入查看模式';
            }
            else {
                editstatus.value = '退出查看模式';
            }
        }
        //判断是否在查看模式
        function iseditstatus() {
            var editstatus = document.getElementById('editstatus');
            if (editstatus.getAttribute('value') == '进入查看模式') {
                return false;
            }
            else {
                return true;
            }
        }
        //清空画布并重设坐标
        function canvasclear(canv) {
            canv.height = canv.height;
            var cont = canv.getContext('2d');
            cont.translate(50, 30);
        }
        //canvas鼠标点击事件
        canvas2.onmouseup = function (e) {
            //判断是否在查看模式
            if (iseditstatus()) {
                var location = getLocation(e.clientX, e.clientY);
                //打开文件
                var xhttp = new XMLHttpRequest();
                var xml = xhttp.responseXML;
                console.log(location);
                //检查是否在点上
                $(xml).find("point").each(function (i) {//查找所有point节点并遍历
                    pointname = $(this).attr("name");  //获取节点的属性
                    pointposition = locationtrans($(this).attr("xPosition"), $(this).attr("yPosition"));
                    console.log(pointname, pointposition);
                    if ((Math.abs(pointposition.x - location.x)< 5) && (Math.abs(pointposition.y - location.y) < 5)) {
                        //Getxmlvalueattr(xml)
                        //draw_lightpoint(pointname, pointposition.x, pointposition.y, context2);
                        console.log(pointname);
                    }
                    draw_point(pointname, pointposition.x, pointposition.y, context2);
                });
                xhttp.open("get", "../XML/test.xml", true);
                xhttp.send();
            }
        }
        //绘制高亮点与点名
        function draw_lightpoint(name, x, y, context) {
            context.beginPath();
            context.fillStyle = 'red';
            context.arc(x, y, 6, 0, 2 * Math.PI);
            context.fill();
            //填入点名
            context.font = '9pt Arial';
            context.fillText(name, x + 7, y + 5);
        }
        //绘制点与点名
        function draw_point(name, x, y, context) {
            context.beginPath();
            context.fillStyle = 'black';
            context.arc(x, y, 6, 0, 2 * Math.PI);
            context.fill();
            //填入点名
            context.font = '9pt Arial';
            context.fillText(name, x + 7, y + 5);
        }
        //加载XML地图
        function drawmap() {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    xmltest(this);
                }
            };
            xhttp.open("get", "../XML/test.xml", true);
            xhttp.send();
        }
        function xmltest(xml) {
            var xmlDoc = xml.responseXML;
            Getxmlvalueattr(xmlDoc);
        }
        function locationtrans(xtrans, ytrans) {
            return {
                x: xtrans / 40,
                y:ytrans/(-40)
            }
        }
        function Getxmlvalueattr(xml) {
            canvasclear(canvas2);
            var pointname = 0;
            var pointposition;//节点坐标
            var sourceposition;//路径起点坐标
            var destinationposition;//路径终点坐标
            var locationlabel = document.getElementById('locationlabel');
            $(xml).find("point").each(function (i) {     //查找所有point节点并遍历
                pointname = $(this).attr("name");  //获取节点的属性
                pointposition = locationtrans($(this).attr("xPosition"), $(this).attr("yPosition"));
                console.log(pointname, pointposition);
                draw_point(pointname, pointposition.x, pointposition.y,context2);
            });
            $(xml).find("path").each(function (i) {     //查找所有path节点并遍历
                sourcepoint = $(this).attr("sourcePoint");  //获取节点的属性
                $(xml).find("point").each(function (i) {     //查找所有point节点并遍历
                    if ($(this).attr('name') == sourcepoint) {
                        sourceposition = locationtrans($(this).attr("xPosition"), $(this).attr("yPosition"));
                        return false;
                    }
                });
                destinationPoint = $(this).attr("destinationPoint");
                $(xml).find("point").each(function (i) {     //查找所有point节点并遍历
                    if ($(this).attr('name') == destinationPoint) {
                        destinationposition = locationtrans($(this).attr("xPosition"), $(this).attr("yPosition"));
                        return false;
                    }
                });
                drawLine(sourceposition.x, sourceposition.y, destinationposition.x, destinationposition.y, context2);
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
        function drawLine(x1, y1, x2, y2, context) {
            context.moveTo(x1, y1);
            context.lineTo(x2, y2);
            context.stroke();
        }

        //鼠标坐标追踪
        canvas2.onmousemove = function (e) {
            var location = getLocation(e.clientX, e.clientY);
            var locationlabel = document.getElementById('locationlabel');
            if (parseInt(location.x) >= 0 && parseInt(location.y) >= 0) {
                locationlabel.innerHTML = "x=" + parseInt(location.x) + " ,y=" + parseInt(location.y);//显示取整后坐标
            }
            else {
                locationlabel.innerHTML = '';
            }
        };
        //获取坐标
        function getLocation(x, y) {
            var bbox = canvas2.getBoundingClientRect();
            return {
                x: (x - bbox.left) * (canvas2.width / bbox.width) - 50,
                y: (y - bbox.top) * (canvas2.height / bbox.height) - 30
            };
        }
        //页面加载事件
        window.onload = function () {
            context1.translate(50, 30);
            context2.translate(50, 30);
            drawAxis(context1);
            //绘制网格的方法
            function drawAxis(cxt) {
                var dx = 0,
                    dy = 50,
                    x = 0,
                    y = 0,
                    w = canvas1.width,
                    h = canvas1.height;
                cxt.lineWidth = 1;
                cxt.strokeStyle = "silver";
                var textX = 50;
                var textY = 0;
                //绘制y轴
                for (var i = 0; i <= w - 50; i += 10) {
                    drawLine(i, 0, i, h, cxt);
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
                    drawLine(0, i, w, i, cxt);
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
</body>
</html>
