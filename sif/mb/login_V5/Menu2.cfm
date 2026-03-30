<form action="loginform.cfm" method="Post">
	<table   cellpadding="0" cellspacing="0" border="5"  >
		<tr>
			<td><a href="javascript:MINI_EXP()"><img border="0" src="images/expan.gif" width="35" height="30"></a></td>
			<td><a href="javascript:SALIR()"><img border="0" src="images/salir.gif" width="35" height="30"></a></td>
	</tr>
  </table>
	<INPUT TYPE="hidden"   id="Logout" name="Logout" value="">
	<INPUT TYPE="hidden"   id="valor" name="valor" value="0">
</form>
 <iframe id="RECARGA"  src="" name="RECARGA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
 
 <cfquery datasource="#session.dsn#"  name="RS_menu">
	select  convert(varchar(100),CGE15NOM)CGE15NOM,CGE19NOM, 
	  substring(CGE19LNK, (charindex('CARPETA=', CGE19LNK) + 8), 
		(
		 (charindex('&PANTALLA=', CGE19LNK)) - (charindex('CARPETA=', CGE19LNK) + 8)
		)
	  ) + '/' +
	  substring(CGE19LNK, (charindex('&PANTALLA=', CGE19LNK) + 10), datalength(CGE19LNK)
	 
	  ) + '.cfm' LINK
	from CGE014 B, CGE019 C, CGE025 D, CGE026 E,CGE015 F
	WHERE B.CGE15COD = C.CGE15COD
	  and B.CGE15COD = F.CGE15COD	
	  and B.CGE16CON = C.CGE16CON
	  and B.CGE15COD in ('CJ', 'CGMN', 'AF')
	  and C.CGE19LNK LIKE '%cjc_PU%'
	  and C.CGE15COD = D.CGE15COD
	  and C.CGE16CON = D.CGE16CON
	  and C.CGE19CON = D.CGE19CON
	  and D.CGE24COD = E.CGE24COD
	  and B.CGE1COD = E.CGE1COD
	  and E.CGE20COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usrID#">
	  and B.CGE1COD = 'IFT'
</cfquery>

<!--- <table width="100%" border="0" cellpadding="4" cellspacing="0" >
	<cfloop query="RS_menu">
		<tr align="left"> 
			<td  id="GAT"  style="background-color:dodgerblue " width="10%">
				<a 	href="javascript:location.reload(); top.frames['workspace'].location.href='../<cfoutput>#RS_menu.LINK#</cfoutput>?IDSESSION=<cfoutput>#session.ID#</cfoutput>'">
					<cfoutput>#RS_menu.CGE19NOM#</cfoutput>
				</a>
			</td>
		</tr>
	</cfloop>
</table> --->


<style type="text/css">
DIV.clSlide{position:absolute;  ;z-index:10; left:0; width:138; height:22; clip:rect(0,138,22,0); padding:3px;}
DIV.clSlideSub{position:absolute; ;z-index:10; padding:2px; clip:rect(0,350,20,0); width:350; height:20; left:8; visibility:hidden}
DIV.clSlideSub2{position:absolute; ;z-index:10; padding:2px; clip:rect(0,218,20,0); width:218; height:20; left:8; visibility:hidden}
#divSlideCont{position:absolute; z-index:10; left:0; top:100; height:600; width:270; visibility:hidden}
A.clSlideLinks{font-family:Verdana, Helvetica, Helv; font-size:11px; font-weight:bold; text-decoration:none; color:white}
A.clSlideSubLinks{font-family:Verdana, Helvetica, Helv; font-size:10px; text-decoration:none; color:Navy}
A.clSlideSub2Links{font-family:Verdana, Helvetica, Helv; font-size:9px; text-decoration:none; color:Navy}
</style>


<script language="JavaScript" type="text/javascript">
function lib_bwcheck(){ //Browsercheck (needed)
	this.ver=navigator.appVersion
	this.agent=navigator.userAgent
	this.dom=document.getElementById?1:0
	this.opera5=(navigator.userAgent.indexOf("Opera")>-1 && document.getElementById)?1:0
	this.ie5=(this.ver.indexOf("MSIE 5")>-1 && this.dom && !this.opera5)?1:0; 
	this.ie6=(this.ver.indexOf("MSIE 6")>-1 && this.dom && !this.opera5)?1:0;
	this.ie4=(document.all && !this.dom && !this.opera5)?1:0;
	this.ie=this.ie4||this.ie5||this.ie6
	this.mac=this.agent.indexOf("Mac")>-1
	this.ns6=(this.dom && parseInt(this.ver) >= 5) ?1:0; 
	this.ns4=(document.layers && !this.dom)?1:0;
	this.bw=(this.ie6 || this.ie5 || this.ie4 || this.ns4 || this.ns6 || this.opera5)
	return this
}
var bw=lib_bwcheck()
//Opera didn't seem to like the padding in the layers, it messes up the background-images, so here's a version without it.
if(bw.opera5) document.write("<style>DIV.clSlide{padding:0px; background-image:url(' ')}\nDIV.clSlideSub{padding:0px; background-image:url(' ')}\nDIV.clSlideSub2{padding:0px; background-image:url(' ')}</style>")

/************************************************************************************
Making cross-browser objects
************************************************************************************/
function makeMenuObj(obj,nest){
	nest=(!nest) ? "":'document.'+nest+'.'										
   	this.css=bw.dom? document.getElementById(obj).style:bw.ie4?document.all[obj].style:bw.ns4?eval(nest+"document.layers." +obj):0;		
	this.el=bw.dom?document.getElementById(obj):bw.ie4?document.all[obj]:bw.ns4?eval(nest+'document.'+obj):0;	
	this.ref=bw.dom || bw.ie4? document:bw.ns4?eval(nest+"document.layers." +obj+".document"):0;		
	this.x=(bw.ns4 || bw.ns5)? this.css.left:this.css.offsetLeft;
	this.y=(bw.ns4 || bw.ns5)? this.css.top:this.css.offsetTop;		
	this.hideIt=b_hideIt; this.showIt=b_showIt; this.movey=b_movey
	this.moveIt=b_moveIt; this.moveBy=b_moveBy; this.status=0; 
	this.bgImg=b_bgImg;	this.obj = obj + "Object"; eval(this.obj + "=this"); 
	this.clipTo=b_clipTo;
	return this
}
function b_showIt(){this.css.visibility="visible"; this.status=1}
function b_hideIt(){this.css.visibility="hidden"; this.status=0}
function b_movey(y){this.y=y; this.css.top=this.y}	
function b_moveIt(x,y){this.x=x; this.y=y; this.css.left=this.x;this.css.top=this.y}
function b_moveBy(x,y){this.x=this.x+x; this.y=this.y+y; this.css.left=this.x;this.css.top=this.y}
function b_bgImg(img){if(bw.ie||bw.dom)this.css.backgroundImage="url("+img+")"
else this.css.background.src=img
}
function b_clipTo(t,r,b,l,w){if(bw.ns4){this.css.clip.top=t;this.css.clip.right=r
this.css.clip.bottom=b;this.css.clip.left=l
}else{this.css.clip="rect("+t+","+r+","+b+","+l+")"; if(w){this.css.width=r; this.css.height=b}}}
/********************************************************************************
Initiating page, making objects..
********************************************************************************/
function SlideMenuInit(){
	oSlideMenu=new makeMenuObj('divSlideCont')
	oSlideMenu.moveIt(menux,menuy)
	oSlide=new Array()
	for(i=0;i<menus.length;i++){
		oSlide[i]=new makeMenuObj('divSlide'+i,'divSlideCont')
		oSlide[i].subs=menus[i].subs
		oSlide[i].sub=new Array()
		oSlide[i].moveIt(0,mainheight*i)
		oSlide[i].starty=oSlide[i].y
    if(bw.opera) oSlide[i].css.paddingLeft="10px"
		if(!menus[i].seperator) oSlide[i].bgImg(level0_regular)
		for(j=0;j<oSlide[i].subs;j++){
			oSlide[i].sub[j]=new makeMenuObj('divSlideSub'+i+"_"+j,'divSlideCont')
			oSlide[i].sub[j].moveIt(10,oSlide[i].y+subheight*j+between)
			oSlide[i].sub[j].starty=oSlide[i].sub[j].y
			oSlide[i][j]=new Array()
			oSlide[i][j].subs=menus[i][j].subs
			oSlide[i][j].sub=new Array()
			img=level1_round
			if(oSlide[i][j].subs!=0){
				if(j!=oSlide[i].subs-1) img=level1_sub
				else img=level1_sub_round
				oSlide[i].sub[j].css.color="white"
			}else{
				if(j!=oSlide[i].subs-1)img=level1_regular
			}
			oSlide[i].sub[j].origimg=img
			oSlide[i].sub[j].bgImg(img)
			for(a=0;a<oSlide[i][j].subs;a++){
				oSlide[i][j].sub[a]=new makeMenuObj('divSlideSub'+i+"_"+j+"_"+a,'divSlideCont')
				oSlide[i][j].sub[a].moveIt(20,oSlide[i].sub[j].y+subheight*a+between-2)
				oSlide[i][j].sub[a].starty=oSlide[i][j].sub[a].y			
				oSlide[i][j][a]=new Array()
				oSlide[i][j][a].subs=menus[i][j][a].subs
				oSlide[i][j][a].sub=new Array()
				if(a!=oSlide[i][j].subs-1) img=level2_regular
				else img=level2_round
				oSlide[i][j].sub[a].origimg=img
				oSlide[i][j].sub[a].bgImg(img)
			}
		}
	}
	oSlideMenu.showIt()
}
/********************************************************************************
Variables
********************************************************************************/
var active=-1;var going;var isthere; var sactive=-1; var sisthere=-1; var s2active=-1; var s2isthere=-1
/********************************************************************************
Switch menu function.
********************************************************************************/
function swmenu(num,snum,s2num){
	if(snum!=-1){
		if(oSlide[num][snum].subs==0) return
	}
	if(s2num!=-1){
		if(oSlide[num][snum][s2num].subs==0) return
	}
	if((num!=active || snum!=sactive || s2num!=s2active) && !going){going=true;isthere=0;sisthere=0;moveUp(num,snum,s2num)}
}
/********************************************************************************
Moving the menus upward to their original position.
********************************************************************************/
function moveUp(num,snum){
	if(snum==-1){
		for(i=0;i<oSlide.length;i++){
			if(oSlide[i].y>oSlide[i].starty+pxspeed && active!=i) oSlide[i].moveBy(0,-pxspeed)
			else{if(active!=i) oSlide[i].moveIt(oSlide[i].x,oSlide[i].starty); isthere=i}
		}
		
		if(isthere<oSlide.length-1) setTimeout("moveUp("+num+","+snum+")",timspeed)
		else swmenu2(num,snum)
	}else{
		if(num==oSlide.length-1) isthere=num
	
		if(sactive!=-1){ //Is out!
			//Slide subs
			j=0
			for(i=sactive+1;i<oSlide[num].sub.length;i++){
				j++
				if(oSlide[num].sub[i].y>oSlide[num].sub[i].starty+pxspeed) oSlide[num].sub[i].moveBy(0,-pxspeed)
				else{oSlide[num].sub[i].moveIt(oSlide[num].sub[i].x,oSlide[num].sub[i].starty); sisthere=i}
			}
			//Slide main
			for(i=num+1;i<oSlide.length;i++){
				if(oSlide[i].y>oSlide[i].starty + oSlide[num].sub[sactive].y +subheight*j )  oSlide[i].moveBy(0,-pxspeed)
				else{oSlide[i].moveIt(oSlide[i].x,oSlide[i].starty + oSlide[num].sub[sactive].y +subheight*j ); isthere=i}
			}
		}else{ //Slide to the one clicked
			for(i=num+1;i<oSlide.length;i++){
				if(oSlide[i].y>oSlide[i].starty + snum*between+between)  oSlide[i].moveBy(0,-pxspeed)
				else{oSlide[i].moveIt(oSlide[i].x,oSlide[i].starty + snum*between+between); isthere=i}
			}
		}
		if(isthere<oSlide.length-1 || (sactive!=-1 && sisthere<oSlide[num].sub.length-1 && sactive!=oSlide[num].sub.length-1)) setTimeout("moveUp("+num+","+snum+")",timspeed)
		else swmenu2(num,snum)
	}
}
/********************************************************************************
Switch menu 2, stuff that happens before the menus are moved down again.
********************************************************************************/
function swmenu2(num,snum){
	isthere=0;
	sisthere=0;
	if(active>-1 && snum==-1){
		//Hiding submenus
		for(j=0;j<oSlide[active].subs;j++){oSlide[active].sub[j].hideIt()}
		oSlide[active].bgImg(level0_regular)
		oSlide[active].moveIt(0,oSlide[active].starty)
	}
	if(sactive>-1){
		//Hiding submenus
		for(j=0;j<oSlide[active][sactive].sub.length;j++){oSlide[active][sactive].sub[j].hideIt()}
		oSlide[active].sub[sactive].bgImg(oSlide[active].sub[sactive].origimg)
		oSlide[active].sub[sactive].moveIt(10,oSlide[active].sub[sactive].starty)
		//Move back to place
		for(i=sactive+1;i<oSlide[active].sub.length;i++){
			oSlide[active].sub[i].moveIt(oSlide[active].sub[i].x,oSlide[active].sub[i].starty)
		}
	}
	active=num
	//Showing submenus
	if(snum>-1){
		sactive=snum
		for(j=0;j<oSlide[num][snum].sub.length;j++){oSlide[num][snum].sub[j].showIt()}
		oSlide[num].sub[snum].moveBy(10,3)
		oSlide[num].sub[snum].bgImg(level1_round2)
	}else{
		sactive=-1
		for(j=0;j<oSlide[active].subs;j++){oSlide[active].sub[j].showIt()}
		oSlide[num].moveBy(10,3)
		oSlide[num].bgImg(level0_round)
	}
	if(num!=oSlide.length-1) moveDown(num,snum)
	else{
		isthere=num
		moveDown(num,snum)
	}
}
/********************************************************************************
Moving the menus down
********************************************************************************/
function moveDown(num,snum){
	//if(num==oSlide.length-1) isthere=num
	for(i=num+1;i<oSlide.length;i++){
		if(snum==-1){
			if(oSlide[i].y<(oSlide[num].subs-1)*subheight+oSlide[i].starty+between-pxspeed) oSlide[i].moveBy(0,pxspeed)
			else{oSlide[i].moveIt(oSlide[i].x,(oSlide[num].subs-1)*subheight+oSlide[i].starty+between); isthere=i}
		}else{
			if(oSlide[i].y<(oSlide[num].subs-1)*subheight+oSlide[i].starty+between-pxspeed + (oSlide[num][snum].subs-1)*subheight+between)  oSlide[i].moveBy(0,pxspeed)
			else{oSlide[i].moveIt(oSlide[i].x,(oSlide[num].subs-1)*subheight+oSlide[i].starty+between  + (oSlide[num][snum].subs-1)*subheight+between); isthere=i}
		}
	}
	if(snum!=-1){
		for(i=snum+1;i<oSlide[num].sub.length;i++){		
			if(oSlide[num].sub[i].y<(oSlide[num][snum].subs-1)*subheight+oSlide[num].sub[i].starty+between-pxspeed) oSlide[num].sub[i].moveBy(0,pxspeed)
			else{oSlide[num].sub[i].moveIt(oSlide[num].sub[i].x,(oSlide[num][snum].subs-1)*subheight+oSlide[num].sub[i].starty+between); sisthere=i}
		}
	}
	if(snum==-1){
		if(isthere<oSlide.length-1) setTimeout("moveDown("+num+","+snum+")",timspeed)
		else going=false
	}else{
		if(isthere<oSlide.length-1 || (sisthere<oSlide[num].sub.length-1 && snum!=oSlide[num].sub.length-1)) setTimeout("moveDown("+num+","+snum+")",timspeed)
		else going=false
	}
}
var test=0
/********************************************************************************
Functions to write out the layers...
********************************************************************************/
menus=new Array(); var a=0; var b=0; var c=0; var d=0   ; var G=0   
function makeMenu(type,text,lnk,target,end){
	str=""; tg="";
  if(target) tg='target="'+target+'"'
  if(!lnk) lnk="#"
  self.status=lnk
	if(a==0) str='<div id="divSlideCont">\n'
	if(type=="top"){
		menus[a]=new Array();
		if(text=="seperator"){
			str+='\t<div id="divSlide'+a+'" class="clSlide"></div>\n'
			menus[a].seperator=1
		}else{
      str+='\t<div id="divSlide'+a+'" class="clSlide"><a href="'+lnk+'" '+tg+' onclick="swmenu('+a+',-1,-1); if(bw.ie || bw.ns6) this.blur(); '
      if(lnk=="#") str+='return false'
      str+='" class="clSlideLinks"> '+text+'</a><br></div>\n'
		}
    menus[a].subs=0; a++; b=0
	}else if(type=="sub"){
		str+=' \t\t<div id="divSlideSub'+(a-1)+'_'+(b)+'"'
		str+=' class="clSlideSub">'
		str+=' <a '+tg
		g = a-1
		pintaopcion
        str+=' href="javascript:pintaopcion(\''+lnk+'\');" class="clSlideSubLinks">  '+text+'</a><br></div>\n'
        //str+=' href=" javascript:top.frames[\'workspace\'].location.href=\''+lnk+'\' ;location.reload();" class="clSlideSubLinks">  '+text+'</a><br></div>\n'
		b++; menus[a-1].subs=b; menus[a-1][b-1]=new Array(); c=0; menus[a-1][b-1].subs=0
	}
	if(end) str+="</div>"
	document.write(str)
}

function preLoadBackgrounds(){
  for(i=0;i<arguments.length;i++){
    this[i]=new Image()
    this[i].src=arguments[i]
  }
  return this
}

function pintaopcion(link) {
		params = "?link="+link+"&id=<cfoutput>#session.ID#</cfoutput>";
		var frame = document.getElementById("RECARGA");
		frame.src = "/cfmx/sif/login_V5/POSTCARGA.cfm"+params;
}
var tam1="110,*";
var tam2="205,*";


function  MINI_EXP(){
	var valor = document.getElementById("valor");
	if(valor.value == "0"){
		valor.value="1";
		top.document.getElementById("topFrame").cols=tam1;
	}
	else{
		valor.value="0";
		top.document.getElementById("topFrame").cols=tam2;

	}	
}
function SALIR(){
	var x1 = document.forms[0];
	x1.submit();
}

//Variables to set
between=28 //The pixel between the menus and the submenus
mainheight=25 //The height of the mainmenus
subheight=22 //The height of the submenus
pxspeed=13 //The pixel speed of the animation
timspeed=15 //The timer speed of the animation
menuy=65//The top placement of the menu.
menux=0 //The left placement of the menu
//Images - Play with these
level0_regular="images/level0_regular.gif"
level0_round="images/level0_round.gif"
level1_regular="images/level1_regular.gif"
level1_round="images/level1_round.gif"
level1_sub="images/level1_sub.gif"
level1_sub_round="images/level1_sub_round.gif"
level1_round2="images/level1_round2.gif"
level2_regular="images/level2_regular.gif"
level2_round="images/level2_round.gif"

//Leave this line
preLoadBackgrounds(level0_regular,level0_round,level1_regular,level1_round,level1_sub,level1_sub_round,level1_round2,level2_regular,level2_round)


//There are 3 different types of menus you can make
//top = Main menus
//sub = Sub menus
//sub2 = SubSub menus

//You control the look of the menus in the stylesheet

//makeMenu('TYPE','TEXT','LINK','TARGET', 'END (THE LAST MENU)')

//Menu 0 
titulo = "";
<cfset CONTADOR 	= 0>
<cfloop query="RS_menu">
	<cfset CONTADOR 	= CONTADOR + 1>
	if (titulo != '<cfoutput>#RS_menu.CGE15NOM#</cfoutput>'){
		titulo  = '<cfoutput>#RS_menu.CGE15NOM#</cfoutput>'
		makeMenu('top',titulo)

	}
	<cfif RS_menu.recordcount GT CONTADOR>
		makeMenu('sub','<cfoutput>#RS_menu.CGE19NOM#</cfoutput>','../<cfoutput>#RS_menu.LINK#</cfoutput>?IDSESSION=<cfoutput>#session.ID#</cfoutput>')
  	<cfelse>
		makeMenu('sub','<cfoutput>#RS_menu.CGE19NOM#</cfoutput>','../<cfoutput>#RS_menu.LINK#</cfoutput>?IDSESSION=<cfoutput>#session.ID#</cfoutput>',"",1)
	</cfif>
</cfloop>
onload=SlideMenuInit;
</script>




