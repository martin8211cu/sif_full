<!--- 
	Creado por Angeles Blanco
		Fecha: 17 Septiembre 2010
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Utilidad Bruta por Orden Comercial'>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">

<cfquery name="rsPeriodo" datasource="sifinterfaces">
	select distinct(E.Periodo) as Periodo from ESIFLD_HFacturas_Venta E
	inner join DSIFLD_HFacturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by E.Periodo desc
</cfquery>

<cfquery name="rsMes" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery name="rsAñoMes" datasource="#session.dsn#">
	select convert(integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=   "#Session.Ecodigo#"> and Pcodigo = 60))  as Mes,
	case convert (integer,(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=     "#Session.Ecodigo#"> and Pcodigo = 60))  when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then    'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when    10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as NomMes,
	(select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    					    "#Session.Ecodigo#"> and Pcodigo = 50) as Año
</cfquery>

<cfoutput>
	<form name="form1" method="post" action="InterfazVtas-CostoOrden-sql.cfm">
	<fieldset><legend align="left">Filtros</legend>
	<table width="99" cellpadding="" cellspacing="0" border="0" align="center"> 	
		
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
				<tr>		
				<td align="left"><strong>Periodo:	</strong></td>
				
           	    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<select name="fltPeriodo" tabindex="5">
						<cfloop query="rsPeriodo">
                    		<option value="#rsPeriodo.Periodo#" <cfif #rsAñoMes.Año# EQ "#rsPeriodo.Periodo#">selected</cfif>>#rsPeriodo.Periodo#
							</option>
               			</cfloop>
					</select>
				</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
				<td align="left"><strong>Mes: </strong></td>
            	<td>
					<select name="fltMes" tabindex="5"> 
		              		<cfloop query="rsMes">
                    		<option value="#rsMes.VSvalor#" <cfif #rsAñoMes.Mes# EQ "#rsMes.VSvalor#">selected</cfif>>#rsMes.VSdesc#</option>     
							</cfloop>
                	</select>
            	</td>
				</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			   	
					<tr><td colspan="2"><cf_botones values="Seleccionar" names="Seleccionar"></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
		</fieldset>		
		</table>
		
	</form>
	
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>

<script language="javascript" type="text/javascript">
	function funcSeleccionar()
		{
			var mensaje = '';
			if (document.form1.fltPeriodo.value == '-1'){
				mensaje += '- Periodo\n';
			}
			if (document.form1.fltMes.value == '-1'){
				mensaje += '- Mes\n';
			}
			if (mensaje != ''){
				alert('Los siguientes campos son requeridos:\n\n' + mensaje)
				return false;
			}
			return true;
		}	
</script>


