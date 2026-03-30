<!---SML. Modificacion 11/10/2013
Se realizo el cambio del reporte, ya que al exportar a Excel no permitia manipular la informacion,
y a su vez se agrego la opcion de seleccionar mas de una incidencia en el reporte, 
porque originalmente solo se podia obtener el reporte de un solo Concepto de Pago--->


<!--- ReporteLibroSalariosFiltro.cfm --->
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EmpleadoFinal" Default="Empleado Final" returnvariable="LB_EmpleadoFinal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfoutput>
<cf_web_portlet_start style="box" titulo="#LB_nav__SPdescripcion#">
	<table width="100%" align="center">
		<tr>
			<td>
            	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
				<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">
				<form action="IncidenciasEmpleado.cfm" method="post" name="form1" style="margin:0">
					<table width="70%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="right" valign="top"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></strong></td>
							<td><cf_rhempleado tabindex="1">&nbsp;</td>
                            
						</tr>
						<tr>
							<td nowrap align="right"> <strong><cf_translate  key="LB_Fechadesde">Fecha desde</cf_translate> :&nbsp;</strong></td>
							<td><cf_sifcalendario form="form1" tabindex="1" name="Fdesde"></td>
						</tr>
						<tr>
							<td nowrap align="right"> <strong><cf_translate  key="LB_Fechahasta">Fecha hasta</cf_translate> :&nbsp;</strong></td>
							<td><cf_sifcalendario form="form1" tabindex="1" name="Fhasta"></td>
						</tr>
						 <tr>
							<td nowrap align="right"> <strong><cf_translate  key="LB_Incidencia">Incidencia</cf_translate> :&nbsp;</strong></td>
							<td>
                            	<table width="100%">
                                	<tr>
                                    	<td width="50%">
                                        	<cf_rhcincidentes form = "form1" id = "CIid">
                                            <!---<input type="hidden" name="CIdescripcion" id="CIdescripcion" value="">	--->
                                            
                                        </td>
                                        <td width="50%">
                                        	<input type="button" name="agregarCar" onClick="javascript:fnNuevoCar();" value="+">
                                        </td>
                                    </tr>   
                                </table>   
                            </td>  
						</tr>
                        <tr>
                        	<td>
                            </td>
                            <td>
                            	<table width="100%" id="tblCar">
                                    <tr>
                                    	<td colspan="2">
                                        <div style="display:none ;" id="verCargas">
						    				<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
										</div>
                                        </td>
                                    </tr>   
                                </table>  
                            </td>
                        </tr>
						<tr>
							<td>&nbsp;</td>
							<td>
                            <!---<input name="HorasExtras" type="checkbox" value="1"><strong><cf_translate  key="LB_HorasExtras">Reporte Horas Extras Dobles y Triples</cf_translate>&nbsp;</strong>
                            <br />--->
                            <input name="Historico" type="checkbox" value="1"><strong><cf_translate  key="LB_Historico">Hist&oacute;rico</cf_translate>&nbsp;</strong></td>
						</tr>
						<tr><th scope="row" colspan="2" class="fileLabel"><cf_botones values="Ver" tabindex="1">&nbsp;</th></tr>
					</table>
			  </form>
			</td>
		</tr>
	</table>
<cf_web_portlet_end>
<cf_qforms>
    <cf_qformsrequiredfield name="Fdesde" description="#LB_FechaRige#">
    <cf_qformsrequiredfield name="Fhasta" description="#LB_FechaVence#">
</cf_qforms>
</cfoutput>

<script language="JavaScript">	
	var vnContadorListas = 0;
	var GvarNewTD;
	
//Función para agregar TRs
	function fnNuevoCar()
	{
	<!---alert('Hola');--->
	  var RHTidSelec = document.form1.CIid.value;
	  var RHTdescSelec = document.form1.CIdescripcion.value;
	  <!---alert(RHTidSelec);
	  
	  alert(RHTdescSelec);--->
	 	  		 	
	  if (RHTidSelec != '' && RHTdescSelec != ''){ 
	 	vnContadorListas = vnContadorListas + 1; 		
	  }
	  
	  var LvarTable = document.getElementById("tblCar");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= RHTidSelec<!---toString()--->;//id
	  var p2 		= RHTdescSelec;//desc
		
	 <!--- document.form1.RHTcodigo.value="";--->
	  RHTidSelec = "";
	  RHTdescSelec = "";

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCar(p1)) {alert('El código seleccionado es repetido.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CaridList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  
	   // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon"; 
	}
	
	function existeCodigoCar(v){
		var LvarTable = document.getElementById("tblCar");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
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
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  vnContadorListas = vnContadorListas - 1;
	  
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}
</script>
