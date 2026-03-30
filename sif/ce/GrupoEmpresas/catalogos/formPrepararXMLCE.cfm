<cfinvoke key="LB_Mapeo" default="Mapeo" returnvariable="LB_Mapeo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Numero" default="Numero de cuentas a generar" returnvariable="LB_Numero" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Enero" default="Enero" returnvariable="LB_Enero" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Febrero" default="Febrero" returnvariable="LB_Febrero" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Marzo" default="Marzo" returnvariable="LB_Marzo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Abril" default="Abril" returnvariable="LB_Abril" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Mayo" default="Mayo" returnvariable="LB_Mayo" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Junio" default="Junio" returnvariable="LB_Junio" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Julio" default="Julio" returnvariable="LB_Julio" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Ogosto" default="Agosto" returnvariable="LB_Agosto" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Septiembre" default="Septiembre" returnvariable="LB_Septiembre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Octube" default="Octubre" returnvariable="LB_Octubre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Niviembre" default="Noviembre" returnvariable="LB_Noviembre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Dicienbre" default="Diciembre" returnvariable="LB_Diciembre" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Preparar" default="Preparar" returnvariable="LB_Preparar" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>
<cfinvoke key="LB_Regresar" default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="formPrepararXMLCE.xml"/>

<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE'AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rfc" datasource="#Session.DSN#">
	SELECT Eidentificacion FROM Empresa WHERE Ereferencia = #Session.Ecodigo#
</cfquery>

<cfif #Len(rfc.Eidentificacion)# gte 12 and #Len(rfc.Eidentificacion)# lte 13>
	<cfset Strfc = #rfc.Eidentificacion#>
	<cfelse>
	<cfset Strfc = ''>
</cfif>

<cfset res = REMatch("[A-ZÑ&]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z0-9]?[A-Z0-9]?[0-9A-Z]?", #Strfc#)>

<cfif #ArrayIsEmpty(res)# eq 'YES'>
	<cfset RFC = '0'>
	<cfelse>
	<cfset RFC = '1'>
</cfif>


<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " and cm.Ctipo <> 'O'">
	</cfif>
</cfif>

<cfquery name="numC" datasource="#Session.DSN#">
	SELECT COUNT(cem.CCuentaSAT) as numero FROM	CEMapeoSAT cem
	inner join CContables cc on cem.Ccuenta = cc.Ccuenta
    inner join (
		select distinct Ccuenta
		from SaldosContables
		where <!---Speriodo = (select YEAR(SYSDATETIME()))
    		and---> Ecodigo = #Session.Ecodigo#
	) Saldos on Saldos.Ccuenta=cc.Ccuenta
    inner join CtasMayor cm on cc.Cmayor = cm.Cmayor
	where cem.Ccuenta Not in (select Ccuenta from CEInactivas) and cem.CAgrupador = #form.CAgrupador#
	<cfif #nivel.Pvalor# neq '-1'>
		AND (SELECT PCDCniv FROM PCDCatalogoCuenta WHERE Ccuentaniv = cem.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#
		<cfelse>
	    AND  (SELECT Cmovimiento FROM CContables WHERE Ccuenta = cem.Ccuenta) = 'S'
	</cfif>
	#PreserveSingleQuotes(LvarOrden)#
</cfquery>
<cfquery name="anio" datasource="#Session.DSN#">
	SELECT YEAR(SYSDATETIME()) as periodo
</cfquery>
<cfif #nivel.Pvalor# neq '-1'>
	<cfset lvarValor = "and (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
	<cfelse>
	<cfset lvarValor = "and cc.Cmovimiento = 'S'">
</cfif>

<cfquery name="totalC" datasource="#Session.DSN#">
	select  COUNT(cc.Ccuenta) as cuentas from CContables cc
    inner join (select distinct  Ccuenta  from SaldosContables where <!---Speriodo = (select YEAR(SYSDATETIME())) and---> Ecodigo = #Session.Ecodigo#  ) Saldos on Saldos.Ccuenta=cc.Ccuenta
    inner join CtasMayor cm on cc.Cmayor = cm.Cmayor
    where cc.Ccuenta Not in (select Ccuenta from CEInactivas)
    #PreserveSingleQuotes(lvarValor)# #PreserveSingleQuotes(LvarOrden)#

	<!---cfif #nivel.Pvalor# neq '-1'>
		select COUNT(Ccuenta) as cuentas from CContables cc where cc.Ccuenta Not in (select Ccuenta from CEInactivas)
	    and (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#
	    <cfelse>
	    select COUNT(Ccuenta) as cuentas from CContables cc where cc.Ccuenta Not in (select Ccuenta from CEInactivas)
        and cc.Cmovimiento = 'S'
	</cfif--->
</cfquery>
<cfquery name="periodo" datasource="#Session.DSN#">
	select Speriodo from CGPeriodosProcesados group by Speriodo order by Speriodo desc
</cfquery>

<cfset LvarRegresar   = 'AgrupadorCuentasSATCE.cfm'>
<cfset LvarAction   = 'SQLPrepararXMLCE.cfm'>
<cfoutput>
	<form action="#LvarAction#" method="post" name="form1" id="form1">
		<table align="center" cellpadding="0" cellspacing="2">

			<tr valign="baseline" >
				<td nowrap align="right">#LB_Mapeo#:&nbsp;</td>
				<td style="vertical-align:bottom">
					Agrupadores SAT V. #form.Version#

				</td>
			</tr>
			<!--- <tr valign="baseline" >
				<td nowrap align="right">#LB_Numero#:&nbsp;</td>
				<td style="vertical-align:bottom">
					#numC.numero# de #totalC.cuentas#
				</td>
			</tr> --->
			<tr valign="baseline" >
				<td nowrap align="right"><strong>#LB_Periodo#:</strong>&nbsp;</td>
				<td style="vertical-align:bottom">
					<select name="selectPeriodo" id="selectPeriodo">
						<option value="value1" <cfif not isdefined('form.Periodo')>selected</cfif>>Escoger uno</option>
						<cfloop query="periodo">
							<option value="#periodo.Speriodo#" <cfif isdefined('form.Periodo')><cfif #form.Periodo# eq #periodo.Speriodo#>selected</cfif></cfif> >#periodo.Speriodo#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr valign="baseline" >
				<td nowrap align="right"><strong>#LB_Mes#:</strong>&nbsp;</td>
				<td style="vertical-align:bottom">
					<select name="selectMes" id="selectMes">
						<option value="value1" <cfif not isdefined('form.Mes')>selected</cfif>>Escoger uno</option>
                        <option value="01" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '01'>selected</cfif></cfif>>#LB_Enero#</option>
                        <option value="02" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '02'>selected</cfif></cfif>>#LB_Febrero#</option>
						<option value="03" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '03'>selected</cfif></cfif>>#LB_Marzo#</option>
                        <option value="04" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '04'>selected</cfif></cfif>>#LB_Abril#</option>
						<option value="05" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '05'>selected</cfif></cfif>>#LB_Mayo#</option>
                        <option value="06" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '06'>selected</cfif></cfif>>#LB_Junio#</option>
						<option value="07" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '07'>selected</cfif></cfif>>#LB_Julio#</option>
						<option value="08" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '08'>selected</cfif></cfif>>#LB_Agosto#</option>
                        <option value="09" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '09'>selected</cfif></cfif>>#LB_Septiembre#</option>
						<option value="10" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '10'>selected</cfif></cfif>>#LB_Octubre#</option>
                        <option value="11" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '11'>selected</cfif></cfif>>#LB_Noviembre#</option>
						<option value="12" <cfif isdefined('form.Mes')><cfif #form.Mes# eq '12'>selected</cfif></cfif>>#LB_Diciembre#</option>
					</select>
				</td>
			</tr>
			<tr valign="baseline">
				<td colspan="2" align="center">
					<input type="submit" name="Preparar" value="#LB_Preparar#" class="btnGuardar" onclick="return funcPreparar()">
					<input type="submit" name="Regresar" value="#LB_Regresar#" class="btnAnterior" onclick="Regresar()">
				</td>
            </tr>

		</table>

		<input type="hidden" name="CAgrupador"  id="CAgrupador" value="#form.CAgrupador#">
		<input type="hidden" name="Version"  id="Version" value="#form.Version#">
		<input type="hidden" name="Periodo"  id="Periodo" value="">
		<input type="hidden" name="Mes"  id="Mes" value="">
		<input name="modo" id="modo" type="hidden" value="">
		<input name="rfc" id="rfc" type="hidden" value="#RFC#">

	</form>
</cfoutput>

    <cfif IsDefined("Form.Error")>
		<cfif #form.Error# eq 1>
		   <script language="javascript" type="text/javascript">
		         alert('El RFC de la empresa no se encuentra registrado');
		   </script>
	    </cfif>
	    <cfif #form.Error# eq 2>
		   <script language="javascript" type="text/javascript">
		         alert('No es posible generar el XML para el catálogo en el periodo-mes solicitado, \ndebido a que ya existe un XML generado para el mismo periodo-mes o posterior');
		   </script>
	    </cfif>
	    <cfif #form.Error# eq 3>
		   <script language="javascript" type="text/javascript">
		         alert('Existen Cuentas sin Mapear, imposible generar el XML de Catalogo de Cuentas.  \n Por favor, complete el mapeo de cuentas y vuelva a intentar');
		   </script>
	    </cfif>
	</cfif>

    <!--- SML. 11/11/2014 Validar que se preparo el XML del mapeo de Cuentas--->
    <cfif isdefined('form.PrepXML') and form.PrepXML EQ 1>
    	  <script language="javascript" type="text/javascript">
		         alert('Se ha preparado correctamente el XML del Mapeo de Cuentas');
		   </script>
    </cfif>

<script language="javascript" type="text/javascript">
	function funcPreparar(){
		var res;
        <!---cfif #numC.numero# eq #totalC.cuentas#--->
			if(document.getElementById('selectPeriodo').value == 'value1'){
				alert('Seleccione un periodo');
				res = false;
			}else{
				if(document.getElementById('selectMes').value == 'value1'){
			    alert('Seleccione un mes');
			    res = false;
		     }else{
		    	document.getElementById('Periodo').value = document.getElementById('selectPeriodo').value;
		    	document.getElementById('Mes').value = document.getElementById('selectMes').value;
		    	if(document.getElementById('rfc').value == 0) {
		    		alert("El RFC de la Empresa no es válido");
		    		res = false;
		    	}else{
		    	   res = true;
		    	}

		      }

	    	}
			<!---cfelse>
			res = false;
		</cfif>
		if(res == false){
			alert('Existen Cuentas sin Mapear, imposible generar el XML de Catalogo de Cuentas.  \n Por favor, complete el mapeo de cuentas y vuelva a intentar')

		}--->



		return res;


	}

	function Regresar(){
		document.getElementById('modo').value = 'CAMBIO';
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
	}


</script>

