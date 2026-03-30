<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CurvaDeDesempenoDesarrolloHumano"
	Default="Curva de Desempe&ntilde;o Desarrollo Humano"
	returnvariable="LB_CurvaDeDesempenoDesarrolloHumano"/>
	
	

<!--- FIN VARIABLES DE TRADUCCION --->
<!--- PARAMETROS DE AREAS DE EVALUACION --->
<cfquery name="rsParamRM" datasource="#session.DSN#">
	select convert(numeric,Pvalor) as Pvalor
	from RHParametros 
	where Pcodigo = 630
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfset ParamRM = rsParamRM.Pvalor>
<cfquery name="rsParamPE" datasource="#session.DSN#">
	select convert(numeric,Pvalor) as Pvalor
	from RHParametros 
	where Pcodigo = 640
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfset ParamPE = rsParamPE.Pvalor>
<cfquery name="rsParamSE" datasource="#session.DSN#">
	select convert(numeric,Pvalor) as Pvalor
	from RHParametros 
	where Pcodigo = 650
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfset ParamSE = rsParamSE.Pvalor>
<cfquery name="rsParamEE" datasource="#session.DSN#">
	select convert(numeric,Pvalor) as Pvalor
	from RHParametros 
	where Pcodigo = 660
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfset ParamEE = rsParamEE.Pvalor>

<!--- INICIALIZACION DE VARIABLES  --->
<cfset Dato1 = 0>
<cfset Dato2 = 0>
<cfset VBrecha1 = 0>
<cfset VBrecha2 = 0>
<cfset VBrecha3 = 0>
<cfset VBrecha4 = 0>
<!--- CANTIDAD DE PERSONAS EN LA RELACION --->
<cfset CantPersonas = rsReporte.RecordCount>
<!--- CALCULO DE BRECHAS --->
<cfset VBrecha1 = Ceiling((CantPersonas/100) * ParamRM)>
<cfset VBrecha2 = Ceiling((CantPersonas/100) * (ParamRM + ParamPE))>
<cfset VBrecha3 = Ceiling((CantPersonas/100) * (ParamRM + ParamPE + ParamSE))>
<cfset VBrecha4 = Ceiling((CantPersonas/100) * (ParamRM + ParamPE + ParamSE + ParamEE))>

<cfset contador=0>
<cfloop query="rsReporte">
	<cfset contador = contador +1>
	<cfif contador EQ VBrecha1>
	<cfset NotaBrecha1= rsReporte.Nota>
	<cfset contador=0>
	<cfbreak>
	</cfif>
</cfloop>
<cfloop query="rsReporte">
	<cfset contador = contador +1>
	<cfif contador EQ VBrecha2>
	<cfset NotaBrecha2= rsReporte.Nota>
	<cfset contador=0>
	<cfbreak>
	</cfif>
</cfloop>
<cfloop query="rsReporte">
	<cfset contador = contador +1>
	<cfif contador EQ VBrecha3>
	<cfset NotaBrecha3= rsReporte.Nota>
	<cfset contador=0>
	<cfbreak>
	</cfif>
</cfloop>
<cfloop query="rsReporte">
	<cfset contador = contador +1>
	<cfif contador EQ VBrecha4>
	<cfset NotaBrecha4= rsReporte.Nota>
	<cfset contador=0>
	<cfbreak>
	</cfif>
</cfloop> 

<cfquery name="rsDatos" dbtype="query">
	select min(Nota) as minimo,max(Nota) as maximo, sum(Nota) as suma
	from rsReporte
</cfquery>
<cfset media = round((1/CantPersonas * rsDatos.suma)*100)/100>
<cfset par = CantPersonas mod 2>
<cfif par EQ 0>
	<cfset Medio = CantPersonas/2>
	<cfset Medio1 = Medio+1>
	<cfloop query="rsReporte">
		<cfset contador = contador +1>
		<cfif contador EQ Medio>
		<cfset Dato1= rsReporte.Nota>
		<cfset contador=0>
		<cfbreak>
		</cfif>
	</cfloop>
	<cfloop query="rsReporte">
		<cfset contador = contador +1>
		<cfif contador EQ Medio1>
		<cfset Dato2= rsReporte.Nota>
		<cfset contador=0>
		<cfbreak>
		</cfif>
	</cfloop>	
	<cfset mediana = (Dato1+Dato2)/2>
<cfelse>
	<cfset Medio = Ceiling(CantPersonas/2)>
	<cfloop query="rsReporte">
		<cfset contador = contador +1>
		<cfif contador EQ Medio>
			<cfset Mediana= rsReporte.Nota>
			<cfset contador=0>
			<cfbreak>
		</cfif>
	</cfloop>	

</cfif>
<!--- TRAE LOS DATOS DEL REPORTE --->
<cfquery name="rsReporte2" dbtype="query">
	select count(1) as CantEmp, Nota, Nota2, NombreEmp
	from rsReporte
	group by Nota,Nota2, NombreEmp
	order by 2

</cfquery>

<cfquery name="rsDS" dbtype="query">
	select sum((Nota-#media#)*(Nota-#media#))/(#CantPersonas#-1) as cuadrado<!--- ,Nota --->
	from rsReporte 
</cfquery>

<cfset desviacion = Sqr(rsDS.cuadrado)>
<cfset DSqrDosPi = (desviacion*Sqr(2*Pi()))>
<cfquery name="rsReporte2" dbtype="query">
	select (((Nota-#Media#)/#desviacion#)*((Nota-#Media#)/#desviacion#))*(-1/2) as CalcExp, 
			Nota,
			Nota2,
			NombreEmp
	from rsReporte
	order by 2
</cfquery>
<cf_dbtemp name="datosG" returnvariable="datosG" datasource="#session.DSN#">
	<cf_dbtempcol name="Descripcion"	type="varchar(255)"	mandatory="yes" > 
	<cf_dbtempcol name="Nota"			type="numeric"		mandatory="yes" > 
	<cf_dbtempcol name="Fx"				type="float"		mandatory="yes" > 		
	<cf_dbtempcol name="ind"			type="int"			mandatory="yes" > 
</cf_dbtemp>	
<cf_dbtemp name="datosB" returnvariable="datosB" datasource="#session.DSN#">
	<cf_dbtempcol name="Descripcion"	type="varchar(255)"	mandatory="yes" > 
	<cf_dbtempcol name="Nota"			type="numeric"		mandatory="yes" > 
	<cf_dbtempcol name="Fx"				type="float"		mandatory="yes" > 		
	<cf_dbtempcol name="ind"			type="int"			mandatory="yes" > 
</cf_dbtemp>
<cfloop query="rsReporte2">
	<cfset valor = exp(rsReporte2.CalcExp)/DSqrDosPi>
		<cfquery name="InsertDG" datasource="#session.DSN#">
			insert into #datosG#(Descripcion,Nota,Fx,ind)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporte2.NombreEmp#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte2.Nota2#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
				0 )
		</cfquery>
</cfloop> 
	<cfif isdefined('NotaBrecha1')>
	<cfset valor = exp((-1*((NotaBrecha1-(Media))/#desviacion#)*((NotaBrecha1-(Media))/#desviacion#))/2)/DSqrDosPi>
	<cfquery name="InsertDG" datasource="#session.DSN#">
		insert into #datosG#(Descripcion,Nota,Fx,ind)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Requiere Mejora">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(fix(NotaBrecha1))#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
			1)
	</cfquery>
	</cfif>
	<cfif isdefined('NotaBrecha2')>
	<cfset valor = exp((-1*((NotaBrecha2-(Media))/#desviacion#)*((NotaBrecha2-(Media))/#desviacion#))/2)/DSqrDosPi>
	<cfquery name="InsertDG" datasource="#session.DSN#">
		insert into #datosG#(Descripcion,Nota,Fx,ind)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Cumple Parcialmente las Espectativa">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(NotaBrecha2))#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
			1 )
	</cfquery>
	</cfif>
	<cfif isdefined('NotaBrecha3')>
	<cfset valor = exp((-1*((NotaBrecha3-(Media))/#desviacion#)*((NotaBrecha3-(Media))/#desviacion#))/2)/DSqrDosPi>
	<cfquery name="InsertDG" datasource="#session.DSN#">
		insert into #datosG#(Descripcion,Nota,Fx,ind)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Cumple Satisfactoriamente las Espectativa">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(NotaBrecha3))#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
			1)
	</cfquery>
	</cfif>
	<cfif isdefined('NotaBrecha4')>
	<cfset valor = exp((-1*((NotaBrecha4-Media)/#desviacion#)*((NotaBrecha4-Media)/#desviacion#))/2)/DSqrDosPi>
	<cfquery name="InsertDG" datasource="#session.DSN#">
		insert into #datosG#(Descripcion,Nota,Fx,ind)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Excede las Espectativa">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(NotaBrecha4))#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
			1)
	</cfquery>
	</cfif>
<!--- *********************** --->
	<cfquery name="rsMax" datasource="#session.DSN#">
		select max(Fx) as maximo, min(Fx) as minimo
		from #datosG#
	</cfquery>
	<cfset valor = rsMax.maximo+0.001>
	<cfif isdefined('NotaBrecha1')>
		<cfquery name="InsertDG" datasource="#session.DSN#">
			insert into #datosB#(Descripcion,Nota,Fx,ind)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Requiere Mejora">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(fix(NotaBrecha1))#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
				1)
		</cfquery>
	</cfif>
	<cfif isdefined('NotaBrecha2')>
		<cfquery name="InsertDG" datasource="#session.DSN#">
			insert into #datosB#(Descripcion,Nota,Fx,ind)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Cumple Parcialmente las Espectativa">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(NotaBrecha2))#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
				1 )
		</cfquery>
	</cfif>
	<cfif isdefined('NotaBrecha3')>
		<cfquery name="InsertDG" datasource="#session.DSN#">
			insert into #datosB#(Descripcion,Nota,Fx,ind)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Cumple Satisfactoriamente las Espectativa">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(NotaBrecha3))#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
				1)
		</cfquery>
	</cfif>
	<cfif isdefined('NotaBrecha4')>
		<cfquery name="InsertDG" datasource="#session.DSN#">
			insert into #datosB#(Descripcion,Nota,Fx,ind)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Excede las Espectativa">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(NotaBrecha4))#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
				1)
		</cfquery>
	</cfif>
	

	<cfquery name="InsertDG" datasource="#session.DSN#">
		insert into #datosG#(Descripcion,Nota,Fx,ind)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Media">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#NumberFormat(Fix(Media))#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">,
			1)
	</cfquery>


<cfquery name="rsReporte2" datasource="#session.DSN#">
	select *
	from #datosG#
	order by Nota
</cfquery>
<cfquery name="rsReporteBrechas" datasource="#session.DSN#">
	select b.Descripcion,coalesce(a.Fx,0) as Fx,b.Nota
	from #datosB# a
	right outer join #datosG# b
	on a.Descripcion = b.Descripcion
	order by b.Nota, Fx
</cfquery>
<cf_htmlReportsHeaders 
	irA="ReporteEvaluacion180.cfm"
	FileName="ReporteEvaluacionDesempenno.xls"
	title=""
	download="no"
	preview="no">

<table width="750" align="center" border="0">
	<tr><td colspan="2">&nbsp;</td></tr>
	<cfoutput>
		<tr><td align="center" colspan="2"><strong>#Trim(Session.Enombre)#</strong></td></tr>
		<tr><td align="center" colspan="2"><strong>#LB_CurvaDeDesempenoDesarrolloHumano#</strong></td></tr>
		</tr>	
			<td align="center"  colspan="2">
				<strong>
				#rsRelacion.REdescripcion#&nbsp;&nbsp;<cf_translate key="LB_Del">del</cf_translate>&nbsp;#lsdateformat(rsRelacion.REdesde,"DD/MM/YYYY")#&nbsp;&nbsp;<cf_translate key="LB_Al">al</cf_translate>&nbsp;#lsdateformat(rsRelacion.REhasta,"DD/MM/YYYY")#
				</strong>
			</td>
		</tr>
		<tr>	
			<td align="center" colspan="2">
				<strong><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong>&nbsp;&nbsp;#lsdateformat(now(),"DD/MM/YYYY")# &nbsp;&nbsp;
		  	</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="2">

			<cfchart 	format="jpg"
						chartWidth="850" 
						chartHeight="300"
						show3d="no"  
						scalefrom="#rsMax.minimo#" 
						scaleto="#rsMax.maximo#" 
						yaxistitle="Fx" 
						xaxistitle="Promedio de Resultados" 
						xaxistype="scale"
						yaxistype="scale" >
					<cfchartseries type="bar" markerstyle="none" seriescolor="CCCCCC"
						query="rsReporteBrechas" 
						itemcolumn="Nota"
						valuecolumn="Fx">
					</cfchartseries>
					<cfchartseries type="line" markerstyle="circle" seriescolor="004080"
						query="rsReporte2" 
						itemcolumn="Nota" 
						valuecolumn="Fx">
					</cfchartseries>

			</cfchart>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="350">
			<cfoutput>
			<table width="100%" cellspacing="2" cellpadding="2" align="left" border="0">
				<tr>
					<td width="150"><strong>M&aacute;ximo</strong></td>
					<td>#NumberFormat(rsDatos.maximo,'99.99')#%</td>
				</tr>
				<tr>
					<td><strong>M&iacute;nimo</strong></td>
					<td>#NumberFormat(rsDatos.minimo,'99.99')#%</td>
				</tr>
				<tr>
					<td><strong>Media</strong></td>
					<td>#NumberFormat(media,'99.99')#%</td>
				</tr>
				<tr>
					<td><strong>Mediana</strong></td>
					<td>#NumberFormat(mediana,'99.99')#%</td>
				</tr>
				<tr>
					<td><strong>Desviaci&oacute;n Est&aacute;ndar</strong></td>
					<td>#desviacion#</td>
				</tr>
			</table>
			</cfoutput>
		</td>
		<td width="350" valign="top">
			<cfoutput>
			<table width="100%" cellspacing="2" cellpadding="2" align="left" border="0">
				<cfif isdefined('NotaBrecha1')>
				<tr>
					<td width="75%" nowrap><strong>Requiere mejora</strong></td>
					<td width="25%" nowrap>De #NumberFormat(rsDatos.minimo,'99.99')#% a #NumberFormat(NotaBrecha1,'99.99')#%</td>
				</tr>
				</cfif>
				<cfif isdefined('NotaBrecha2')>
				<tr>
					<td nowrap><strong> Cumple Parcialmente las Espectativas</strong></td>
					<td nowrap>De #NumberFormat(NotaBrecha1+0.0001,'99.99')#% a #NumberFormat(NotaBrecha2,'99.99')#%</td>
				</tr>
				</cfif>
				<cfif isdefined('NotaBrecha3')>
				<tr>
					<td nowrap><strong>Cumple Satisfactoriamente las Espectativas</strong></td>
					<td nowrap>De #NumberFormat(NotaBrecha2+0.0001,'99.99')#% a #NumberFormat(NotaBrecha3,'99.99')#%</td>
				</tr>
				</cfif>
				<cfif isdefined('NotaBrecha4')>
				<tr>
					<td nowrap><strong>Excede las Espectativas</strong></td>
					<td nowrap>De #NumberFormat(NotaBrecha3+0.0001,'99.99')#% a #NumberFormat(NotaBrecha4,'99.99')#%</td>
				</tr>
				</cfif>
			</table>
			</cfoutput>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr class="noprint"><td colspan="2" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='ReporteEvaluacion180.cfm'"></td></tr>
</table>