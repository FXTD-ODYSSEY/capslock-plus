#include demo.ahk

/*
不打算修改程序本身，只想为某个按键实现功能的话，可以在这里：
1. 添加 keyfunc_xxxx() 的函数，
2. 在 Capslock+settings.ini [keys]下添加设置，
例如按下面这样写，然后添加设置：caps_f7=keyFunc_test2(apple)
3. 保存，重载 capslock+ (capslock+F5)
4. 按下 capslock+F7 试试
***********************************************
*/

keyFunc_winPin2()
{
    _id:=WinExist("A")
    ; WinSet, Style, ^0x800000, A
    
    ; WinSet, Style, ^0xC00000 ; 隐藏标题窗口
    ; WinSet, ExStyle, ^0x80 ; 最大最小化按钮切换
    ; WinSet, ExStyle, ^0xC00000 ; 翻转标题
    
    WinGetTitle, Title, A
    WinGet, ExStyle, ExStyle
    if (ExStyle & 0x8) {
        WinSet, AlwaysOnTop, Off
        p := RegExMatch(Title, "^\^ ", match)
        origin := SubStr(Title, 3)
        if (p = 1)
            WinSetTitle, %origin%
    } else {
        WinSetTitle, ^ %Title%
        WinSet, AlwaysOnTop
    }
    ;  WinSet, Transparent, 210
    return
}

keyfunc_listary(shortKey="")
{
    ClipboardOld:=ClipboardAll
    
    ; 获取选中的文字
    selText:=getSelText()
    
    ; 发送 ctrl ctrl 按键（Listary默认的呼出快捷键），呼出Listary
    if (shortKey = "") {
        
        SendInput, {RControl}
        Sleep, 100
        SendInput, {RControl}
    } else {
        p := RegExMatch(shortKey, "[a-zA-Z0-9 ]*$", match)
        modifier := SubStr(shortKey, 1 , p-1)
        ; MsgBox,%modifier%{%match%}
        ; 输出按键
        SendInput , %modifier%{%match%}
    }
    
    
    
    ; 等待 Listary 输入框打开
    winwait, ahk_exe Listary.exe, , 0.5
    
    ; 如果有选中文字的话
    if(selText) {
        ; ; 在选中的字前面加上"gg "（因为谷歌搜索是我最常用的，你也可以不加）
        ; selText:="gg " . selText
        ; ; 输出刚才复制的文字，并按一下`home`键将光标移到开头，以方便加入其它关键词
        ; sendinput, %selText%{home}
        
        Clipboard:="bing " . selText
        SendInput, ^{v}
    }
    
    Sleep, 200
    Clipboard:=ClipboardOld
}

keyfunc_test2(str)
{
    msgbox, % str
    return
}