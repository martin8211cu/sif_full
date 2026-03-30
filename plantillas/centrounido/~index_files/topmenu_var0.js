/***********************************************************************************
*   (c) Ger Versluis 2000 version 5.41 24 December 2001           *
*   For info write to menus@burmees.nl                *
*   You may remove all comments for faster loading            *     
***********************************************************************************/

    var NoOffFirstLineMenus=3;          // Number of first level items
    var LowBgColor='00558E';         // Background color when mouse is not over
    var LowSubBgColor='00558E';          // Background color when mouse is not over on subs
    var HighBgColor='00558E';            // Background color when mouse is over
    var HighSubBgColor='00558E';         // Background color when mouse is over on subs
    var FontLowColor='ffffff';           // Font color when mouse is not over
    var FontSubLowColor='ffffff';            // Font color subs when mouse is not over
    var FontHighColor='FF9900';          // Font color when mouse is over
    var FontSubHighColor='FF9900';           // Font color subs when mouse is over
    var BorderColor='00558E';            // Border color
    var BorderSubColor='00558E';         // Border color for subs
    var BorderWidth=1;              // Border width
    var BorderBtwnElmnts=1;         // Border between elements 1 or 0
    var FontFamily="verdana,arial,comic sans ms,technical";  // Font family menu items
    var FontSize=7.5;             // Font size menu items
    var FontBold=0;             // Bold menu items 1 or 0
    var FontItalic=0;               // Italic menu items 1 or 0
    var MenuTextCentered='center';            // Item text position 'left', 'center' or 'right'
    var MenuCentered='left';            // Menu horizontal position 'left', 'center' or 'right'
    var MenuVerticalCentered='top';     // Menu vertical position 'top', 'middle','bottom' or static
    var ChildOverlap=.2;                // horizontal overlap child/ parent
    var ChildVerticalOverlap=.2;            // vertical overlap child/ parent
    var StartTop=0;               // Menu offset x coordinate
    var StartLeft;  // Menu offset y coordinate
    StartLeft = 0; 
    var VerCorrect=0;               // Multiple frames y correction
    var HorCorrect=0;               // Multiple frames x correction
    var LeftPaddng=0;               // Left padding
    var TopPaddng=0;                // Top padding
    var FirstLineHorizontal=1;          // SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
    var MenuFramesVertical=1;           // Frames in cols or rows 1 or 0
    var DissapearDelay=200;            // delay before menu folds in
    var TakeOverBgColor=1;          // Menu frame takes over background color subitem frame
    var FirstLineFrame='navig';         // Frame where first level appears
    var SecLineFrame='space';           // Frame where sub levels appear
    var DocTargetFrame='space';         // Frame where target documents appear
    var TargetLoc='topmenudiv';               // span id for relative positioning
    var HideTop=0;              // Hide first level when loading new document 1 or 0
    var MenuWrap=1;             // enables/ disables menu wrap 1 or 0
    var RightToLeft=0;              // enables/ disables right to left unfold 1 or 0
    var UnfoldsOnClick=0;           // Level 1 unfolds onclick/ onmouseover
    var WebMasterCheck=0;           // menu tree checking on or off 1 or 0
    var ShowArrow=1;                // Uses arrow gifs when 1
    var KeepHilite=1;               // Keep selected path highligthed
    var Arrws=['http://www.centrounido.org/img/tri.gif',5,10,'http://www.centrounido.org/img/tridown.gif',10,5,'http://www.centrounido.org/img/trileft.gif',5,10];   // Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}          
function AfterCloseAll(){return}


// Menu tree
//  MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//  For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

 Menu1=new Array("Pagina principal","http://www.centrounido.org/index.php?changezone=0","",0,13,99);
 Menu2=new Array("Miembros","http://www.centrounido.org/index.php?mod=members","",0,13,62);
 Menu3=new Array("¿Cómo pueden contactarnos?","http://www.centrounido.org/index.php?mod=common&cmd=standard&sid=14","",0,13,204);


