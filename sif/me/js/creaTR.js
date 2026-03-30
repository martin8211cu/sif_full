var GvarNewTD;

function fnNuevoTR()
{
  var LvarTable = document.getElementById("tbldynamic");
  var LvarTbody = LvarTable.tBodies[0];
  var LvarTR    = document.createElement("TR");
  
  // Agrega <TD class="class"><INPUT type="TYPE" name="name" value="value"></TD>
  sbAgregaTdInput (LvarTR, "class", "value", "HIDDEN", "name");

  // Agrega <TD class="class"><INPUT type="TYPE" name="name" value="value"></TD>
  sbAgregaTdText  (LvarTR, "class", "value");

  sbAgregaTdImage (LvarTR, "class", "name");
  if (document.all)
	GvarNewTD.attachEvent ("onclick", sbEliminarTR);
  else
	GvarNewTD.addEventListener ("click", sbEliminarTR, false);

  LvarTR.name = "XXXXX";
  LvarTbody.appendChild(LvarTR);
}

function sbEliminarTR(e)
{
  var LvarTR;
  if (document.all)
	LvarTR = e.srcElement;
  else
	LvarTR = e.currentTarget;

  while (LvarTR.name != "XXXXX")
	LvarTR = LvarTR.parentNode;
	
  LvarTR.parentNode.removeChild(LvarTR);
}

function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre)
{
  // Copia una imagen existente
  var LvarTDimg    = document.createElement("TD");
  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
  LvarImg.style.display="";
  LvarTDimg.appendChild(LvarImg);
  if (LprmClass != "") LvarTDimg.className = LprmClass;

  GvarNewTD = LvarTDimg;
  LprmTR.appendChild(LvarTDimg);
}

function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
{
  var LvarTD    = document.createElement("TD");

  var LvarTxt   = document.createTextNode(LprmValue);
  LvarTD.appendChild(LvarTxt);
  if (LprmClass!="") LvarTD.className = LprmClass;
  GvarNewTD = LvarTD;
  LprmTR.appendChild(LvarTD);
}

function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
{
  var LvarTD    = document.createElement("TD");

  var LvarInp   = document.createElement("INPUT");
  LvarInp.type = LprmType;
  if (LprmName!="") LvarInp.name = LprmName;
  if (LprmValue!="") LvarInp.value = LprmValue;
  LvarTD.appendChild(LvarInp);
  if (LprmClass!="") LvarTD.className = LprmClass;
  GvarNewTD = LvarTD;
  LprmTR.appendChild(LvarTD);
}