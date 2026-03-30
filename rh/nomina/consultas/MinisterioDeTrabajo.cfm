<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Anno" Default="A&ntilde;o" returnvariable="LB_Anno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="LB_Todas" Default="--- Todas ---" returnvariable="LB_Todas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EsteTipoDeNominaYaFueAgregado" Default="Este tipo de nómina ya fue agregada" returnvariable="MSG_EsteTipoDeNominaYaFueAgregado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ListaDeNominas" Default="Lista de N&oacute;minas" returnvariable="MSG_ListaDeNominas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronTiposDeNominas" Default="No se encontraron tipos de n&oacute;minas" returnvariable="MSG_NoSeEncontraronTiposDeNominas" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- CONSULTA DE DEPARTAMENTOS --->
<cfset rsNominas = queryNew("value,description","Varchar,Varchar")>
<cfset queryAddRow(rsNominas,1)>
<cfset querySetCell(rsNominas,"value",'',rsNominas.recordcount)>
<cfset querySetCell(rsNominas,"description",LB_Todas,rsNominas.recordcount)>
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
    select ltrim(rtrim(Tcodigo)) as v, Tdescripcion as d
    from TiposNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfloop query="rsTiposNomina">
	<cfset queryAddRow(rsNominas,1)>
	<cfset querySetCell(rsNominas,"value",v,rsNominas.recordcount)>
	<cfset querySetCell(rsNominas,"description",d,rsNominas.recordcount)>
</cfloop>


<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="filtro" method="post" action="MinisterioDeTrabajo-form.cfm">
				<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
                      	<td width="50%">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteDelMinisterioDeTrabajoConLaInformacionDeLosEmpleadosOTrabajadoresPermanentes. ">
                            	Reporte del Ministerio de Trabajo con la informaci&oacute;n de los Empleados o Trabajadores permanetes.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	<tr>
                                	<td align="right"><cf_translate key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate>:</td>
                                    <td>
                                    	<cf_conlis
											campos="Tcodigo,Tdescripcion"
											desplegables="S,S"
											modificables="S,N"
											size="10,25"
											title="#MSG_ListaDeNominas#"
											tabla="TiposNomina a"
											columnas="a.Tcodigo,a.Tdescripcion"
											filtro="	a.Ecodigo=#SESSION.ECODIGO#
														order by a.Tcodigo"
											desplegar="Tcodigo,Tdescripcion"
											filtrar_por="Tcodigo, Tdescripcion"
											etiquetas="#LB_Codigo#, #LB_Descripcion#"
											formatos="S,S"
											align="left,left"
											asignar="Tcodigo, Tdescripcion"
											asignarformatos="S, S"
											showEmptyListMsg="true"
											EmptyListMsg="-- #MSG_NoSeEncontraronTiposDeNominas# --"
											tabindex="1"
											form="filtro">
										
                                    </td>
									<td>
										<input type="hidden" name="LastOneTN" id="LastOneTN" value="ListaNon">
										<input type="button" name="agregarCF" 
										onClick="javascript:if (window.fnNuevoTN) fnNuevoTN();" value="+" tabindex="1">
									</td>
                                </tr>
								<tr>
									<td colspan = "3">
										<table id="tbltipoNomina" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
											<tbody>
											</tbody>
										</table>
									</td>
								</tr>
                            	<tr>
                                	<td align="right"><cf_translate key="LB_Anno">A&ntilde;o</cf_translate>:</td>
                                    <td><cf_rhperiodos name="anno" tabindex="1"></td>
                                </tr>
                            </table>
                        </td>
                   	</tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr><td nowrap align="center" colspan="2"><cf_botones values="Generar" tabindex="1"></td></tr>
              </table>
          </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="filtro">
	<cf_qformsrequiredfield args="anno,#LB_Anno#">
</cf_qforms>
<script language="javascript" type="text/javascript">
	var vnContadorListas = 0;
	//Función para agregar TRs
	function fnNuevoTN()
	{
	  if (document.filtro.Tcodigo.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tbltipoNomina");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.filtro.LastOneTN;
	  var p1 		= document.filtro.Tcodigo.value;//cod
	  var p2 		= document.filtro.Tdescripcion.value;//desc

	  document.filtro.Tcodigo.value="";
	  document.filtro.Tdescripcion.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoTN(p1)) {alert('<cfoutput>#MSG_EsteTipoDeNominaYaFueAgregado#</cfoutput>');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "TcodigoList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  	
	  // Agrega Evento de borrado en Columna 2
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
	
	function existeCodigoTN(v){
		var LvarTable = document.getElementById("tbltipoNomina");
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
	
	//Función para agregar TDs con Objetos
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