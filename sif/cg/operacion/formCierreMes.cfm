<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoContable" default="Per&iacute;odo Contable" 
returnvariable="LB_PeriodoContable" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesContable" default="Mes Contable" 
returnvariable="LB_MesContable" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EstaSeguro" default="Esta seguro que desea procesar el cierre de mes contable" returnvariable="LB_EstaSeguro" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Procesar" default="Procesar Cierre de Mes" 
returnvariable="BTN_Procesar" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CierreEmpresa" default="¿Desea procesar el cierre de mes contable para la empresa" returnvariable="LB_CierreEmpresa" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CierreExitoso" default="Cierre de Mes Contable Finalizada Exitosamente" returnvariable="LB_CierreExitoso" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Lote" default="Lote" 
returnvariable="LB_Lote" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Poliza" default="P&oacute;liza" 
returnvariable="LB_Poliza" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;" 
returnvariable="LB_Descripcion" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Peri&oacute;do" 
returnvariable="LB_Periodo" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" 
returnvariable="LB_Fecha" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" 
returnvariable="LB_Monto" xmlfile="formCierreMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Asientos" default="Asientos Recursivos a Generar" 
returnvariable="LB_Asientos" xmlfile="formCierreMes.xml"/>
<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif #Form.modo# EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>

<cfif isdefined("url.IDcontable") and len(trim(url.IDcontable))>
	<cfquery datasource="#session.DSN#">
        delete from AsientosRecursivos 
        where Ecodigo = #session.Ecodigo# 
        and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDcontable#">
    </cfquery>
</cfif>
<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>


<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_dbfunction name="to_char" args="a.Eperiodo" returnvariable='LvarEperiodo'>
<cf_dbfunction name="to_char" args="a.Emes" returnvariable='LvarEmes'>
<cfset LvarFecha = "#LvarEperiodo# #_Cat# ' / ' #_Cat# #LvarEmes#">
<cfquery name="rsListaRecursivo" datasource="#Session.DSN#" maxrows="900">
	select
			a.IDcontable, 
			a.Edocumento, 
			<cf_dbfunction name='string_part' args="a.Edescripcion,1,60"> as Edescripcion,
			 #preservesinglequotes(LvarFecha)#  as Periodo,  
			a.Efecha, 
			coalesce((
				select sum(Dlocal)
				from HDContables d
				where d.IDcontable = a.IDcontable
				  and d.Dmovimiento = 'D'
				  ), 0.00) as Monto,
			a.ECfechaaplica as fechaAplica,
			a.Cconcepto as Cconcepto
	from HEContables a
        	inner join AsientosRecursivos b
            	on b.IDcontable = a.IDcontable
                and b.Ecodigo = a.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
	order by a.Cconcepto, a.Edocumento, a.Eperiodo desc, a.Emes desc			
</cfquery>



<cfinclude template="Funciones.cfm">
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">

<form method="post" name="form1" action="SQLCierreMes.cfm">
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr>			
			<td width="40%" align="right" style="padding-right: 20px" nowrap>
				<b><cfoutput>#LB_PeriodoContable#</cfoutput></b>
			</td>
			<td align="left" style="padding-right: 10px">
				<cfoutput>#periodo#</cfoutput>
			</td>
			<td align="right" style="padding-left: 10px; padding-right: 20px" nowrap>
				<b><cfoutput>#LB_MesContable#</cfoutput></b>
			</td>
			<td width="40%" align="left">
				<cfoutput>#mes#</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="4">
				<br/>
				<cfif isdefined("Form.showMessage")>
					<script language="JavaScript" type="text/javascript">
						alert("<cfoutput>#LB_CierreExitoso#</cfoutput>");
					</script>
				</cfif>
				<cfoutput>#LB_CierreEmpresa#</cfoutput> <b><cfoutput query="rsEmpresa">#rsEmpresa.Edescripcion#</cfoutput></b>? 
			</td>
		</tr>
		<tr>
			<td align="center" colspan="4">
				<br/><cfoutput>
				<input type="submit" name="btnCierre" value="#BTN_Procesar#" onclick="javascript:return confirm('#LB_EstaSeguro#?');"/>
			</cfoutput></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<table width="100%" cellpadding="0" cellspacing="0"><cfoutput>
  		<tr>
			<td align="center" colspan="6"><strong>#LB_Asientos#</strong></td>
        </tr>      
  		<tr bgcolor="CCCCCC">
			<td><strong>#LB_Lote#</strong></td>
			<td><strong>#LB_Poliza#</strong></td>
			<td><strong>#LB_Descripcion#</strong></td>
			<td><strong>#LB_Periodo#</strong></td>
			<td><strong>#LB_Fecha#</strong></td>
			<td><strong>#LB_Monto#</strong></td>
            <td>&nbsp;</td>
        </tr>      </cfoutput>
        <cfoutput query="rsListaRecursivo">
        	<tr>
            	<td>#Cconcepto#</td>
            	<td>#Edocumento#</td>
            	<td>#Edescripcion#</td>
            	<td>#Periodo#</td>
            	<td>#dateformat(Efecha, "DD/MM/YYYY")#</td>
            	<td>#numberformat(Monto, ",9.00")#</td>
                <td><input  name="btnBorrar" type="image" alt="Eliminar elemento" onClick="javascript: sbBorrar('#IDcontable#'); return false;" src="../../imagenes/Borrar01_T.gif" width="16" height="16"></td>
            </tr>
        </cfoutput>
    </table>
</form>

<script language="javascript" type="text/javascript">
	var ff = document.form1;
		function sbBorrar(data) {
			location.href="CierreMes.cfm?btnBorrar=1&IDcontable=" + data;
		}
</script>  

