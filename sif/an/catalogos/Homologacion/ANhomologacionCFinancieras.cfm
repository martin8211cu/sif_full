<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TipoH" 	default="Tipo de Homologaci&oacute;n" 
returnvariable="LB_TipoH" xmlfile="ANhomologacionCFinancieras.xml"/>LB_CuentasH
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CuentasH" 	default="Cuenta de Homologaci&oacute;n" 
returnvariable="LB_CuentasH" xmlfile="ANhomologacionCFinancieras.xml"/>
<table>
	<cf_navegacion name="ANHid">
	<cf_navegacion name="ANHCid">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 
			h.ANHcodigo,
			h.ANHdescripcion,
			c.ANHCcodigo,
			c.ANHCdescripcion
		from ANhomologacionCta c
			inner join ANhomologacion h
			 on h.ANHid = c.ANHid
		where c.Ecodigo	= #session.Ecodigo#
		  and c.ANHid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ANHid#">
		  and c.ANHCid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ANHCid#">
	</cfquery>
	<cfoutput>
	<table width="80%">
		<tr>
			<td  valign="top" width="10%">&nbsp;</td>
			<td  valign="top" width="30%"><strong>#LB_TipoH#:</strong>&nbsp;</td>
			<td  valign="top">#rsSQL.ANHcodigo# - #rsSQL.ANHdescripcion#</td>
			<td  valign="top" align="right" rowspan="2">
				<input type="button" value="#BTN_Regresar#"
					 onclick="location.href='ANhomologacionCta.cfm?ANHid=#url.ANHid#&ANHCid=#url.ANHCid#';"
				>
			</td>
		</tr>	
		<tr>
			<td  valign="top" width="10%">&nbsp;</td>
			<td  valign="top"><strong>#LB_CuentasH#:</strong>&nbsp;</td>
			<td  valign="top">#rsSQL.ANHCcodigo# - #rsSQL.ANHCdescripcion#</td>
		</tr>	
		<tr>
			<td  valign="top" width="10%">&nbsp;</td>
			<td  valign="top" colspan="3">
				<cfquery name="rslista" datasource="#session.dsn#">
					select 	DISTINCT
							#url.ANHid# as ANHid, f.ANHCid, c.CFcuenta,
							c.CFformato, coalesce(c.CFdescripcionF,c.CFdescripcion) as CFdescripcion, c.CFmovimiento,
							case when f.AnexoSigno = 1 then '+' else '-' end as signo
						from ANhomologacionFmts f
							inner join CFinanciera c
							 on c.Ecodigo	= #session.Ecodigo#
							and c.Cmayor	= f.Cmayor
							and <cf_dbfunction name="like" args="c.CFformato,f.AnexoCelFmt">
							and c.CFmovimiento = 'S'
						where f.ANHCid = #form.ANHCid#
					order by c.CFformato
				</cfquery>	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
					<cfinvokeargument name="query" 			  value="#rslista#"/>
					<cfinvokeargument name="desplegar"  	  value="signo,CFformato,CFdescripcion,CFmovimiento"/>
					<cfinvokeargument name="etiquetas"  	  value="Signo,Cuenta Financiera,Descripcion,Movs"/>
					<cfinvokeargument name="formatos"   	  value="S,S,S,S"/>
					<cfinvokeargument name="align" 			  value="center,left,left,center"/>
					<cfinvokeargument name="ajustar"   		  value="N"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys"             value="ANHid,ANHCid,CFcuenta"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="irA"              value="ANhomologacionCta.cfm"/>
					<cfinvokeargument name="pageindex"        value="2"/>
					<cfinvokeargument name="formname"        value="lista2"/>
					<cfinvokeargument name="showLink"        value="no"/>
					<cfinvokeargument name="lineaRoja"        value="signo EQ '-'"/>
				</cfinvoke> 
			</td>
		</tr>	
	</table>
	</cfoutput>


