var canvas1;
var context1;
var canvas2;
var context2;
var canvas3;
var context3;
var canvas4;
var context4;
var locationlabel;



//页面加载事件
window.onload = function () {
    //初始化canvas
    initcanvas();
    //绘制网格及坐标
    drawAxis(context1);
    locationlabel = document.getElementById('locationlabel');
};
//初始化convas及context
function initcanvas() {
    canvas1 = document.getElementById('canvas1');
    context1 = canvas1.getContext('2d');
    context1.translate(50, 30);
    canvas2 = document.getElementById('canvas2');
    context2 = canvas2.getContext('2d');
    context2.translate(50, 30);
    canvas3 = document.getElementById('canvas3');
    context3 = canvas3.getContext('2d');
    context3.translate(50, 30);
    canvas4 = document.getElementById('canvas4');
    context4 = canvas4.getContext('2d');
    context4.translate(50, 30);
}
//绘制网格及坐标
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
//清空画布并重设坐标
function canvasclear(canv) {
    canv.height = canv.height;
    var cont = canv.getContext('2d');
    cont.translate(50, 30);
}
//canvas鼠标点击事件
function canvasmouseup(e) {
    var location = getLocation(e.clientX, e.clientY);
    var infolabel = document.getElementById('infolabel');
    infolabel.innerHTML = '';
    infolabel.style.display = 'none';
    //打开文件
    var xhttp = new XMLHttpRequest();
    xhttp.open("get", "../XML/test.xml", true);
    xhttp.send();
    console.log(location);
    canvasclear(canvas4);
    //检查是否在点上
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var xml = xhttp.responseXML;
            $(xml).find("point").each(function (i) {//查找所有point节点并遍历
                pointname = $(this).attr("name");  //获取节点的属性
                pointposition = locationtrans($(this).attr("xPosition"), $(this).attr("yPosition"));
                if ((Math.abs(pointposition.x - location.x) < 15) && (Math.abs(pointposition.y - location.y) < 15)) {
                    infolabel.innerHTML = ' ' + pointname + '' + '\n' +
                        '坐标:' + parseInt(location.x) + ',' + parseInt(location.y) + '\n' +
                        '类型' + $(this).attr("type");
                    infolabel.style.display = 'block';
                    infolabel.style.left = parseInt(location.x) + 60 + 'px';
                    infolabel.style.top = parseInt(location.y) + 25 + 'px';
                    draw_lightpoint(pointname, pointposition.x, pointposition.y, context4);//高亮绘制选中的点
                }
            });
        }
    };
}
//绘制高亮点与点名
function draw_lightpoint(name, x, y, context) {
    context.beginPath();
    context.fillStyle = 'red';
    context.arc(x, y, 10, 0, 2 * Math.PI);
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
//实际坐标与视图坐标转换
function locationtrans(xtrans, ytrans) {
    return {
        x: xtrans / 40,
        y: ytrans / (-40)
    }
}
//加载xml地图并绘制
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
        draw_point(pointname, pointposition.x, pointposition.y, context2);
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

//绘制直线（含起终点坐标）
function drawLine(x1, y1, x2, y2, context) {
    context.moveTo(x1, y1);
    context.lineTo(x2, y2);
    context.stroke();
}

//鼠标坐标追踪
function canvasmousemove(e) {
    var location = getLocation(e.clientX, e.clientY);
    if (parseInt(location.x) >= 0 && parseInt(location.y) >= 0) {
        locationlabel.style.left = parseInt(location.x) + 60 + 'px';
        locationlabel.style.top = parseInt(location.y) + 25 + 'px';
        locationlabel.innerHTML = "(" + parseInt(location.x) + " ," + parseInt(location.y) + ')';//显示取整后坐标
    }
    else {
        locationlabel.innerHTML = '';
    }
};
//获取鼠标相对canvas坐标
function getLocation(x, y) {
    var bbox = canvas4.getBoundingClientRect();
    return {
        x: (x - bbox.left) * (canvas4.width / bbox.width) - 50,
        y: (y - bbox.top) * (canvas4.height / bbox.height) - 30
    };
}
