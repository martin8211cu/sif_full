<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Lista de Datos Variables para el Servicio</title>
</head>

<body>
<cf_templatecss>
<cfquery name="rsConcepto" datasource="#Session.DSN#">
	select Cid, CCid from Conceptos
    where Ecodigo = #session.Ecodigo#
    and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Cid#">
</cfquery>

<cfif not isdefined ("url.DTlinea")>
	<cfthrow message="No esta definida la transaccion, por la tanto no se puede asociar datos variables">
</cfif>

<cfif not isdefined("url.tran")> 
    <cfset url.tran = "">    
</cfif> 

<cfif not isdefined("url.caja")> 
    <cfset url.caja = "">    
</cfif> 

<cfoutput>
<form name="form1" style="margin:0;" action="SQLTransaccionesFA.cfm">
<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td align="center" class="tituloAlterno">Datos Adicionales para #url.desc#</td>
	</tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td colspan="5">        
        	<input type="hidden" value="#url.DTlinea#" name="DTlinea" />
            <input type="hidden" value="#url.tran#"  name="ETnumero" />
            <input type="hidden" value="#url.caja#"  name="FCid" />
            <input type="hidden" value="#rsConcepto.Cid#"  name="Servicio" />
            <input type="hidden" value="#rsConcepto.CCid#"  name="Clasificacion" />

			<cfset Tipificacion = StructNew()>
            <cfset temp = StructInsert(Tipificacion, "FA", "")> 
            <cfset temp = StructInsert(Tipificacion, "FA_CLASIF", "#rsConcepto.CCid#")> 
            <cfset temp = StructInsert(Tipificacion, "FA_CONCEP", "#rsConcepto.Cid#")> 
            <fieldset>
                <legend><cf_translate key="LB_InformacionOtrosDatos">Otros Datos del Servicio</cf_translate></legend>
                <cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
                <cfinvokeargument name="DVTcodigoValor" value="FA">
                <cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
                <cfinvokeargument name="DVVidTablaVal"  value="#url.DTlinea#">
                <cfinvokeargument name="NumeroColumas"  value="2">
                <cfinvokeargument name="DVVidTablaSec" 	value="0">
                </cfinvoke>
                <cfif Cantidad EQ 0>
                	<div align="center">No Existen Datos Variables Asignados al Servicio</div>
                </cfif>
            </fieldset>
        </td>
    </tr>
</table>
</cfoutput>

<table id="tablabotones2" width="100%" cellpadding="0" cellspacing="0" border="0" >
<tr>
    <td align="center">
        <input type="submit" onclick="javascript: this.form.botonSel.value = this.name;" value="Agregar" tabindex="3" name="AgregarDV" class="btnNormal">
        <input type="submit" tabindex="0" onclick="javascript: if (window.funcCerrar) return funcCerrar();window.close();" value="Cerrar" class="btnNormal" name="btnCerrar">
        <input type="hidden" value="" name="botonSel">
    </td>
</tr>
</table>
<cfif Cantidad GT 0>
	<cfinvoke component="sif.Componentes.DatosVariables" method="QformDatoVariable">
		<cfinvokeargument name="DVTcodigoValor" value="FA">
		<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
		<cfinvokeargument name="DVVidTablaVal"  value="#url.DTlinea#">
		<cfinvokeargument name="DVVidTablaSec" 	value="2"> 
		<cfinvokeargument name="objForm" 		value="form1">
	</cfinvoke>
</cfif>
</form>
</body>
</html>

