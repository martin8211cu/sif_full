<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid >
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cf_dbfunction name="to_char" args="ebe.RHEBEid"	returnvariable="to_RHEBEid">
<cf_dbfunction name="to_char" args="0"	returnvariable="to_0">
<cf_dbfunction name="to_char" args="1"	returnvariable="to_1">
<cfset ver = '<label onclick="fnVerBeca(''#_CAT##to_RHEBEid##_CAT#'',''#_CAT#case when RHEBEestado in(10,20,30,40,50,60) then #to_0# when RHEBEestado = 70 then #to_1# else #to_0# end#_CAT#'')" style="cursor:pointer"><img src="/cfmx/rh/imagenes/findsmall.gif" border="0"></label>'>	
<table width="100%" border="0" cellspacing="0" align="center">
  	<tr>
    	<td valign="top">
		
			<!--- etiquetas de traduccion----->
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Solicitado" Key="LB_Solicitado" returnvariable="LB_Solicitado"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Pendiente" Key="LB_Pendiente" returnvariable="LB_Pendiente"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Rechazado por jefatura" Key="LB_Rechazado_por_jefatura" returnvariable="LB_Rechazado_por_jefatura"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Aprobado por jefatura" Key="LB_Aprobado_por_jefatura" returnvariable="LB_Aprobado_por_jefatura"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Rechazado por Vicerectoría" Key="LB_Rechazado_por_Vicerectoria" returnvariable="LB_Rechazado_por_Vicerectoria"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Aprobado por Vicerectoría" Key="LB_Aprobado_por_Vicerectoria" returnvariable="LB_Aprobado_por_Vicerectoria"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Rechazado por Comité de becas" Key="LB_Rechazado_por_Comite_de_becas" returnvariable="LB_Rechazado_por_Comite_de_becas"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Aprobado por Comité de becas" Key="LB_Aprobado_por_Comite_de_becas" returnvariable="LB_Aprobado_por_Comite_de_becas"/>
				
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Beca" Key="LB_Beca" returnvariable="LB_Beca"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Fecha de Solicitud" Key="LB_Fecha_de_Solicitud" returnvariable="LB_Fecha_de_Solicitud"/>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Estado" Key="LB_Estado" returnvariable="LB_Estado"/>
				
            <cfinvoke 
             component="rh.Componentes.pListas"
             method="pListaRH"
             returnvariable="pListaRet">
                <cfinvokeargument name="tabla" value="RHEBecasEmpleado ebe 
                                                        inner join RHTipoBeca tb on tb.RHTBid = ebe.RHTBid"/>
                <cfinvokeargument name="columnas" value="RHEBEid, ebe.RHTBid, ebe.DEid, RHTBdescripcion, RHEBEfecha,
															case RHEBEestado 
																when 10 then '#LB_Solicitado#' 
																when 15 then '#LB_Pendiente#' 
																when 20 then '#LB_Rechazado_por_jefatura#' 
																when 30 then '#LB_Aprobado_por_jefatura#' 
																when 40 then '#LB_Rechazado_por_Vicerectoria#' 
																when 50 then '#LB_Aprobado_por_Vicerectoria#' 
																when 60 then '#LB_Rechazado_por_Comite_de_becas#' 
																when 70 then '#LB_Aprobado_por_Comite_de_becas#' 
																else '' end as RHEBEestado, '#preservesinglequotes(ver)#' as ver"/>
                <cfinvokeargument name="desplegar" value="RHTBdescripcion, RHEBEfecha, RHEBEestado, ver"/>
                <cfinvokeargument name="etiquetas" value="#LB_Beca#,#LB_Fecha_de_Solicitud#,#LB_Estado#,"/>
                <cfinvokeargument name="formatos" value="V, D, U,S"/>
                <cfinvokeargument name="filtro" value="ebe.Ecodigo = #session.Ecodigo# and ebe.DEid = #form.DEid#"/>
                <cfinvokeargument name="align" value="left, left, left, left, center"/>
                <cfinvokeargument name="ajustar" value="S"/>
                <cfinvokeargument name="checkboxes" value="N"/>				
                <cfinvokeargument name="irA" value="RegBecas.cfm"/>
                <cfinvokeargument name="mostrar_filtro" value="yes"/>
                <cfinvokeargument name="showLink" value="false"/>
                <cfinvokeargument name="filtrar_por_delimiters" value="|"/>
                <cfinvokeargument name="filtrar_por" value="RHTBdescripcion||"/>
                <cfinvokeargument name="keys" value="RHEBEid"/>
            </cfinvoke>
		</td>
	</tr>
</table>
<script language="javascript1.2" type="text/javascript">
	
	var popup_win = null;
	<cfset LvarUri='/cfmx/rh/progEstudios/operacion/becas-popUp.cfm'>
	<cfif isDefined("LvarAuto")>
		<cfset LvarUri='/cfmx/rh/autogestion/consultas/becas-popUp.cfm'>
	</cfif>
	function fnVerBeca(id,version){
		var PARAM  = "<cfoutput>#LvarUri#</cfoutput>?Auto=true&RHEBEid="+id+"&RHDBEversion="+version;
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		popup_win = window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=no,width=800,height=600')
		return false;
	}
</script>