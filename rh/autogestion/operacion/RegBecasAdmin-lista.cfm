<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cf_dbfunction name="to_char" args="ebe.RHEBEid"	returnvariable="to_RHEBEid">
<cfset detalles = '<a href"" onclick="return fnVerDetalles(''#_CAT##to_RHEBEid##_CAT#'')"><img src="/cfmx/rh/imagenes/find.small.png" border="0"></a>'>
<cfparam name="action" default="RegBecas-sql.cfm">
<cfoutput>
<cfparam name="accionPopUp" default="RegBecasAcciones-popUp.cfm">
	<form name="form1" action="#action#" method="post">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
   	<tr><td>
	<cfset reselect = QueryNew("value,description","cf_sql_integer,cf_sql_varchar")>
	<cfset QueryAddRow(reselect,4)>
	<cfset QuerySetCell(reselect,"value","",1)>
	<cfset QuerySetCell(reselect,"description","Todos",1)>
	<cfset QuerySetCell(reselect,"value",15,2)>
	<cfset QuerySetCell(reselect,"description","Pendiente",2)>
	<cfset QuerySetCell(reselect,"value",30,3)>
	<cfset QuerySetCell(reselect,"description","Aprobado por Jefatura",3)>
	<cfset QuerySetCell(reselect,"value",20,4)>
	<cfset QuerySetCell(reselect,"description","Rechazado por Jefatura",4)>
	
    <cfinvoke 
     component="rh.Componentes.pListas"
     method="pListaRH"
     returnvariable="pListaRet">
        <cfinvokeargument name="tabla" value="RHEBecasEmpleado ebe 
                                                inner join DatosEmpleado de on de.DEid = ebe.DEid
                                                inner join RHTipoBeca tb on tb.RHTBid = ebe.RHTBid
                                                #tabla#"/>
        <cfinvokeargument name="columnas" value="RHEBEid, ebe.RHTBid, ebe.DEid, RHTBdescripcion, DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido2 as Empleado, RHEBEfecha, case RHEBEestado when 10 then 'Solicitado' when 15 then 'Pendiente' when 20 then 'Rechazado por jefatura' when 30 then 'Aprobado por jefatura' when 40 then 'Rechazado por Vicerectoría' when 50 then 'Aprobado por Vicerectoría' when 60 then 'Rechazado por Comité de becas' when 70 then 'Aprobado por Comité de becas' else '' end as RHEBEestado, '#preservesinglequotes(detalles)#' as detalles"/>
        <cfinvokeargument name="desplegar" value="RHTBdescripcion, Empleado, RHEBEfecha, RHEBEestado, detalles"/>
        <cfinvokeargument name="etiquetas" value="#LB_Beca#,#LB_Empleado#,#LB_Fecha#,#LB_Estado#"/>
        <cfinvokeargument name="formatos" value="V, V, D, ,U,S"/>
        <cfinvokeargument name="filtro" value="#filtro#"/>
        <cfinvokeargument name="align" value="left, left, left, left, right"/>
        <cfinvokeargument name="ajustar" value="S"/>
        <cfinvokeargument name="checkboxes" value="S"/>				
        <cfinvokeargument name="mostrar_filtro" value="yes"/>
		<cfinvokeargument name="rsRHEBEestado" value="#reselect#"/>
        <cfinvokeargument name="filtrar_por_delimiters" value="|"/>
        <cfinvokeargument name="filtrar_por" value="RHTBdescripcion|DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido2|RHEBEfecha"/>
        <cfinvokeargument name="showLink" value="false"/>
        <cfinvokeargument name="irA" value="RegBecas-sql.cfm"/>
        <cfinvokeargument name="keys" value="RHEBEid"/>
        <cfinvokeargument name="formName" value="form1"/>
        <cfinvokeargument name="incluyeForm" value="false"/>
    </cfinvoke>
    </td></tr>
    <tr><td align="center">
    	<cf_botones values="Aprobar,Rechazar" names="Aprobar#sufijo#,Rechazar#sufijo#" align="center">
    <cfif isdefined('jefe')>
        <input type="hidden" name="RHEBEjustificacionJef" id="RHEBEjustificacionJef" value="" />
        <input type="hidden" name="RHEBEsesionJef" 		  id="RHEBEsesionJef" 		 value="" />
        <input type="hidden" name="RHEBEarticuloJef" 	  id="RHEBEarticuloJef" 	 value="" />
        <input type="hidden" name="RHEBEfechaJef"     	  id="RHEBEfechaJef" 		 value="" />
    <cfelseif isdefined('vice')>
    	<input type="hidden" name="RHEBEjustificacionVic" id="RHEBEjustificacionVic" value="" />
    </cfif>
    </td></tr>
    </table>
</form>
<script language="javascript1.2" type="text/javascript">
	
	var popup_win = null;
	
	function fnVerDetalles(id){
		var PARAM  = "/cfmx/rh/progEstudios/operacion/becas-popUp.cfm?RHEBEid="+id;
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		popup_win = window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=no,width=800,height=600')
		return false;
	}
	
	function funcAprobar#sufijo#(){
		<cfif isdefined('jefe')>
			return fnAbrirPopUp(1);
		<cfelseif isdefined('vice')>
			if(!fnAlgunoMarcadoform1()){
				alert("Al menos una linea debe estar marcada.");
				return false;
			}
			if(confirm("Este seguro de aprobar la(s) beca(s)?"))
				return true;
			else
				return false;
		<cfelse>
			return false;
		</cfif>
	}
	
	function funcRechazar#sufijo#(){
		return fnAbrirPopUp(2);
	}
	
	function fnAbrirPopUp(tipo){
	
		if(!fnAlgunoMarcadoform1()){
			alert("Al menos una linea debe estar marcada.");
			return false;
		}
		var PARAM  = "#accionPopUp#?Tipo="+tipo+"&accion=#accion#";
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		popup_win = window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=no,width=600,height=200');
		return false;
	}
</script>
</cfoutput>