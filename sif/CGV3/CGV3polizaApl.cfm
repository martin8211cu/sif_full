<!--- 
	Modificado por Gustavo Fonseca. 
	Fecha: 18-1-2006.
	Motivo: se corrige el mensaje de página expirada al utilizar el link de REGRESAR, pues usaba la 
	función "backREG". se usa un "formsql" con el action hacia la página de inicio del proceso y se pone Abril en vez de Abrril.
--->

<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function funcObjetos(paramvalor){
		popUpWindow('ObjetosDocumentosCons.cfm?IDcontable='+paramvalor,200,100,700,500);
	}
</script>

<cfquery name="rsPerMes" datasource="#Session.DSN#">
	select Eperiodo, Emes, Edescripcion, Cconcepto, Edocumento, Efecha, Ereferencia, Edocbase
	from HEContables
	where Ecodigo = #Session.Ecodigo#
	and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
</cfquery>
<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
<cfquery name="rsDatosPersonales" datasource="#Session.DSN#">
	select <cf_dbfunction name="sPart" args="rtrim(ltrim(g.Pnombre))#_Cat#' '#_Cat#rtrim(ltrim(g.Papellido1))#_Cat#' '#_Cat#rtrim(ltrim(g.Papellido2)); 1; 50" delimiters=";"> as Pnombre,
	e.ECfechaaplica,  e.ECusucodigoaplica 
	from HEContables e
		inner join Usuario f 
			on e.ECusucodigoaplica =  f.Usucodigo
		inner join DatosPersonales g
			on f.datos_personales = g.datos_personales
	where e.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
</cfquery>

<cfif isdefined("rsDatosPersonales") and rsDatosPersonales.RecordCount NEQ 0>
	<cfset NombreAplica = rsDatosPersonales.Pnombre>
	<cfset FechaAplica = rsDatosPersonales.ECfechaaplica>
	<cfelse>
	<cfset NombreAplica =  ''>
	<cfset FechaAplica =  ''>
</cfif>

<cfparam name="Form.Ccuenta" default="">

<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Código del Parámetro --->">
	<cfquery datasource="#Session.DSN#" name="rsget_val">
		select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
	</cfquery>
	<cfreturn #rsget_val#>
</cffunction>

<cffunction name="get_moneda" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Código de la Moneda --->">
	<cfquery datasource="#Session.DSN#" name="rsget_moneda">
		select Mnombre from Monedas
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">
	</cfquery>
	<cfreturn #rsget_moneda#>
</cffunction>

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfsavecontent variable="myquery">
	<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
	<cfoutput>
		<cfif not isdefined("url.Export")>
			select 
			a.IDcontable, 
			a.Dlinea, 
			a.Ecodigo, 
			a.Eperiodo, 
			a.Emes as Emes, 
			a.Cconcepto as CconceptoQuery, 
			a.Edocumento, 
			a.Ocodigo,
			d.Oficodigo, 
			a.Ddescripcion , 
			a.Ddocumento, 
			a.Dreferencia, 
			case when Dmovimiento='D' then 'Debito' else 'Credito' end as DMovimiento, 
			Dmovimiento as tipoMov,
			a.Ccuenta,
			b.Cformato, 
			b.Cdescripcion,
			a.Doriginal, 
			a.Dlocal, 
			c.Mnombre, 
			a.Dtipocambio,
			case when cf.CFid is not null then
				rtrim(cf.CFcodigo) #_CAT# '-' #_CAT# rtrim(cf.CFdescripcion)
			else
				''
			end
			as CentroFuncional
			from HDContables a
				inner join CContables b
					on b.Ccuenta = a.Ccuenta
				inner join Monedas c
					on c.Mcodigo = a.Mcodigo
				inner join Oficinas d
					on d.Ecodigo = a.Ecodigo
					and d.Ocodigo = a.Ocodigo
				left outer join CFuncional  cf
						on cf.CFid = a.CFid
			where IDcontable = #Form.IDcontable#
		<cfelse>
			select 
				a.Eperiodo as Periodo, 
				a.Emes as Mes, 
				a.Cconcepto as Concepto, 
				a.Edocumento as Documento_Encabezado, 
				d.Oficodigo as Oficina, 
				a.Ddescripcion as Descripcion, 
				a.Ddocumento as Documento, 
				a.Dreferencia as Referencia, 
				case when Dmovimiento='D' then 'Debito' else 'Credito' end as Movimiento, 
				Dmovimiento as Tipo_Mov,
				b.Cformato as Cuenta_Formato, 
				b.Cdescripcion as DescCuenta,
				a.Doriginal as Original, 
				a.Dlocal as Local, 
				c.Mnombre as Moneda, 
				a.Dtipocambio as Tipo_Cambio,
				case when cf.CFid is not null then
				rtrim(cf.CFcodigo) #_CAT# '-' #_CAT# rtrim(cf.CFdescripcion)
				else
					''
				end
				as CentroFuncional
				from HDContables a
					inner join CContables b
						on b.Ccuenta = a.Ccuenta
					inner join Monedas c
						on c.Mcodigo = a.Mcodigo
					inner join Oficinas d
						on d.Ecodigo = a.Ecodigo
						and d.Ocodigo = a.Ocodigo
					left outer join CFuncional  cf
						on cf.CFid = a.CFid
			where IDcontable = #Form.IDcontable#
		</cfif>
	</cfoutput>
</cfsavecontent>

<cfquery name="rsParametro" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 981
</cfquery>
<cfset LvarParametro = 0>
<cfif isdefined("rsParametro") and rsParametro.recordcount eq 1>
		<cfset LvarParametro= rsParametro.Pvalor>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaContable = t.Translate('PolizaContable','P&oacute;liza Contable')>
<cfset ConsPolCont = t.Translate('ConsPolCont','Consulta de P&oacute;lizas Contables')>


<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
</style>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr>
			<td colspan="15" align="center"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr>
			<td colspan="15" class="subTitulo" align="center"><strong>#ConsPolCont#</strong></td>
		</tr>
		<tr>
			<td colspan="15" align="center">&nbsp; </td>
		</tr>
	</cfoutput>
</cfsavecontent>	
<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
 
<cfquery name="rsDocumento" datasource="#session.DSN#">
	select count(1) as cantidad
	from HDContables
	where IDcontable = #Form.IDcontable#
</cfquery>

<form name="form1" method="post" action="saldosymov02.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif rsDocumento.cantidad EQ 0>
			<cfoutput>#encabezado1#</cfoutput>
		</cfif>		
		<cfset Lvarcontador = 0>
        <cftry>
            <cfquery name="rsProc" datasource="#session.dsn#">
                #preservesinglequotes(myquery)#
            </cfquery>
            <cfcatch type="any">
                <cfrethrow>
            </cfcatch>
        </cftry>
         <cfif isdefined("url.Export")>
                <cfset Lvarnombre = "PolizaContable_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
                <cf_exportQueryToFile query="#rsProc#" filename="#Lvarnombre#" jdbc="false">
        </cfif>
        <cfflush interval="32">
        <cfoutput query="rsProc"> 
			<cfif currentRow mod 40 EQ 1>
				<cfif currentRow NEQ 1>
					<tr class="pageEnd"><td colspan="15">&nbsp;</td></tr>
				</cfif>
				#encabezado1#
				<tr>
					<td colspan="15"  nowrap>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:15%"><font size="2">Per&iacute;odo:</font></td>
								<td colspan="4"><font size="2"><strong>#ListGetAt(meses, rsPermes.Emes, ',')#&nbsp;#rsPerMes.Eperiodo#</strong></font></td>
							</tr>

							<tr>
								<td><font size="2">#PolizaContable#:</font></td>
								<td colspan="3"><font size="2"><strong>#CconceptoQuery# - #Edocumento#</strong></font></td>
								<td><font size="2">Fecha Documento: <strong>#dateformat(rsPerMes.Efecha, 'dd/mm/yyyy')#</strong></font></td>

							</tr>
							<tr>
								<td><font size="2">Referencia:</font></td>
								<td colspan="3"><strong>#rsPerMes.Ereferencia#</strong></td>
								<td><font size="2">Documento Base:&nbsp;&nbsp;&nbsp;<strong>#rsPerMes.Edocbase#</strong></font></td>
							</tr>					
							<tr>
								<td><font size="2">Descripción:</font></td>
								<td colspan="4"><strong>#rsPerMes.Edescripcion#</strong></td>
							</tr>					
							<tr>
								<td><font size="2">Usuario:</font></td>
								<td colspan="4"><font size="2"><strong><cfif len(NombreAplica)>#NombreAplica#<cfelse>Sin definir</cfif> (<cfif len(FechaAplica)>#dateformat(FechaAplica, 'dd/mm/yyyy')#<cfelse>&nbsp;</cfif>)</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>	
				<tr>			
					<td colspan="15"  nowrap  style="padding-right: 20px">&nbsp;</td>
				</tr>		
				<tr bgcolor="##E4E4E4">
					<td align="left" width="94" ><font size="2">L&iacute;nea</font></td>
					<td width="23">&nbsp;</td>
					<td width="280"><font size="2">Cuenta</font></td>
					<cfif LvarParametro>
						<td width="280"><font size="2">Desc. Cuenta</font></td>
					</cfif>
					<td width="127"><font size="2">Oficina</font></td>
					<td width="13">&nbsp;</td>
					<td width="614"><font size="2">Centro Funcional</font></td>
					<td>&nbsp;</td>
					<td width="614" align="left"><font size="2">Descripci&oacute;n</font></td>
					<td nowrap align="right"><font size="2">D&eacute;bitos</font></td>
					<td width="1%" align="left">&nbsp;</td>
					<td nowrap align="right"><font size="2">Cr&eacute;ditos</font></td>
					<td width="1">&nbsp;</td>
					<td width="111" align="right"><font size="2">Moneda</font></td>
					<td width="1">&nbsp;</td>
					<td width="105" align="right" nowrap><font size="2">Monto Origen</font></td>
				</tr>
			</cfif>				
			<tr <cfif Form.CCuenta EQ Ccuenta>style="font-weight:bold"</cfif>>
				<td >
					#Dlinea#
				</td>
				<td>&nbsp;</td>
				<td nowrap>
					#Cformato#
				</td>
				<cfif LvarParametro>
					<td>
						#Cdescripcion#
					</td>
				</cfif>
				<td>#Oficodigo#</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>
					<cfif len(CentroFuncional) GT 35>
						#Mid(CentroFuncional,1,35)#...
					<cfelse>
						#CentroFuncional#
					</cfif>
				</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>
					<cfif len(Ddescripcion) GT 35>
						#Mid(Ddescripcion,1,35)#...
					<cfelse>
						#Ddescripcion#
					</cfif>
				</td>
				<td align="right" nowrap>
					<cfif Dmovimiento EQ "Debito">
						#LSCurrencyFormat(DLocal,'none')#
					<cfelse>
						#LSCurrencyFormat(0,'none')#
					</cfif>
				</td>
				<td>&nbsp;</td>
				<td nowrap align="right">
					<cfif #Dmovimiento# EQ "Credito">
						#LSCurrencyFormat(Dlocal,'none')#
					<cfelse>
						#LSCurrencyFormat(0,'none')#
					</cfif>
				</td>
				<td>&nbsp;</td>
				<td  align="right" nowrap>
					#Mnombre# 
				</td>
				<td>&nbsp;</td>
				<td align="right">
					#LSCUrrencyFormat(Doriginal,'none')#
				</td>
			</tr>
		</cfoutput>
		<tr>
			<td colspan="<cfif LvarParametro>9<cfelse>8</cfif>">&nbsp;</td>
			<td align="right" nowrap>--------------------</td>
			<td>&nbsp;</td>
			<td align="right" nowrap>--------------------</td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<cfquery name="rsTotDebCre" datasource="#session.DSN#">
				select 
					sum(case when Dmovimiento = 'D' then Dlocal else 0.00 end) as Debitos,
					sum(case when Dmovimiento = 'C' then Dlocal else 0.00 end) as Creditos
				from HDContables 
				where IDcontable = #form.IDcontable# 
			</cfquery>
			
			<td colspan="<cfif LvarParametro>8<cfelse>7</cfif>">&nbsp;</td>
			<td align="right"><strong>Total:</strong></td>
			<td nowrap align="right">
				<strong><cfoutput>#LSCurrencyFormat(rsTotDebCre.Debitos,'none')#</cfoutput></strong>
			</td>
			<td>&nbsp;</td>
			<td align="right" nowrap>
				<strong><cfoutput>#LSCurrencyFormat(rsTotDebCre.Creditos,'none')#</cfoutput></strong>
			</td>
			<td colspan="6">&nbsp;</td>
		</tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr>
			<TD colspan="15" align="center">_________________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_________________________</TD>
		</tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15" align="center">----------------------------------- Fin de la Consulta -----------------------------------</td></tr>
	</table>
 </form>
<script language="javascript" type="text/javascript">
	function backREG(){
		document.formsql.submit();
	}	
</script>	


