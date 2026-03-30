<table width="100%" cellpadding="5" cellspacing="3">
	<tr>
		<td align="left" valign="top" width="45%" >
			<cfquery datasource="#session.dsn#" name="listaDet">	
				select
					c.CFcuenta,
					a.GEAid,
					a.GELAtotal,
					a.GELid,
					a.GEADid,
					(c.GEADmonto-c.GEADutilizado) as Saldo,
					b.GECdescripcion as GECdescripcion,
					f.CFformato,
					d.GEAnumero,
					d.GEAfechaSolicitud,
					m.Miso4217,
					1 as Det,
					d.GEAviatico as viaticos,
					case 
							when 
								 d.GEAviatico = '1'  
							then 
								'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
							else
								'<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
							end as viaticoIco   
				from 
					GEliquidacionAnts a,GEanticipoDet c,GEconceptoGasto b,CFinanciera f,GEanticipo d, Monedas m
				where	 
					 b.GECid=c.GECid	and			
					a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
					and c.GEAid=a.GEAid
					and c.GEADid=a.GEADid
					and  f.CFcuenta = c.CFcuenta
					and d.GEAid=a.GEAid
					and d.Mcodigo= m.Mcodigo
					and coalesce(d.GEAviatico,'0') = '0' 
				union
				select distinct 
					0 as CFcuenta,
					a.GEAid,
					d.GEAtotalOri as GELAtotal,
					a.GELid,
					0 as GEADid,
					d.GEAtotalOri as Saldo,
					d.GEAdescripcion as GECdescripcion,
					'-' as CFformato,
					d.GEAnumero,
					d.GEAfechaSolicitud,
					m.Miso4217,
					1 as Det,
					d.GEAviatico as viaticos,
					case 
							when 
								 d.GEAviatico = '1'  
							then 
								'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
							else
								'<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
							end as viaticoIco   
				from 
					GEliquidacionAnts a,GEanticipo d, Monedas m
				where	 
					a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
					and d.GEAid=a.GEAid
					and d.Mcodigo= m.Mcodigo
					and d.GEAviatico = '1'
			</cfquery>
		
			<cfif LvarSAporComision>
				<cfset LvarViatico1 = "">
				<cfset LvarViatico2 = "">
			<cfelse>
				<cfset LvarViatico1 = ",viaticoIco">
				<cfset LvarViatico2 = ",Viatico">
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#listaDet#"
				desplegar="GEAnumero,GEAfechaSolicitud,GECdescripcion,Miso4217,Saldo,GELAtotal#LvarViatico1#"
				etiquetas="Anticipo,Fecha,Concepto,Moneda,Saldo,Monto<BR>&nbsp;Liquidar#LvarViatico2#"
				formatos="S,D,S,S,M,M,S"
				align="center,center,center,center,right,right,center"
				ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm"
				showEmptyListMsg="yes"
				keys="GEADid"
				maxRows="5"
				formName="lista_anticipos"
				PageIndex="1"
				form_method="post"
				showLink="yes"
				navegacion="&GELid=#form.GELid#"
				/>
		</td>
		<td valign="top" width="70%">
			<cfinclude template="Tab1_Anticipos_form.cfm">
		 	&nbsp;
		</td>
	</tr>
</table>

            	
		          
