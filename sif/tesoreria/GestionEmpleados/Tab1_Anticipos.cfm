<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Anticipo" Default="Anticipo" returnvariable="LB_Anticipo" xmlfile = "Tab1_Anticipos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" xmlfile = "Tab1_Anticipos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Concepto" Default="Concepto" returnvariable="LB_Concepto" xmlfile = "Tab1_Anticipos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda" returnvariable="LB_Moneda" xmlfile = "Tab1_Anticipos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Saldo" Default="Saldo" returnvariable="LB_Saldo" xmlfile = "Tab1_Anticipos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoLiquidar" Default="Monto Liquidar" returnvariable="LB_MontoLiquidar" 
xmlfile = "Tab1_Anticipos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Viatico" Default="Vi&aacute;tico" returnvariable="LB_Viatico" 
xmlfile = "Tab1_Anticipos.xml"/>
        
<table width="100%" cellpadding="5" cellspacing="3">
	<tr>
		<td align="left" valign="top" width="45%" >
			<cfquery datasource="#session.dsn#" name="listaDet">	
				select
					a.GELid,
					a.GEAid,
					c.CFcuenta,
					a.GELAtotal,
					a.GEADid,
					(c.GEADmonto-c.GEADutilizado) as Saldo,
					b.GECdescripcion as GECdescripcion,
					f.CFformato,
					d.GEAnumero,
					d.GEAfechaSolicitud,
					m.Miso4217,
					1 as tab,
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
					a.GELid,
					a.GEAid,
					0 as CFcuenta,
					d.GEAtotalOri as GELAtotal,
					0 as GEADid,
					d.GEAtotalOri as Saldo,
					d.GEAdescripcion as GECdescripcion,
					'-' as CFformato,
					d.GEAnumero,
					d.GEAfechaSolicitud,
					m.Miso4217,
					1 as tab,
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
				<cfset LvarViatico2 = ",#LB_Viatico#">
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#listaDet#"
				desplegar="GEAnumero,GEAfechaSolicitud,GECdescripcion,Miso4217,Saldo,GELAtotal#LvarViatico1#"
				etiquetas="#LB_Anticipo#,#LB_Fecha#,#LB_Concepto#,#LB_Moneda#,#LB_Saldo#,#LB_MontoLiquidar##LvarViatico2#"
				formatos="S,D,S,S,M,M,S"
				align="center,center,center,center,right,right,center"
				ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm"
				showEmptyListMsg="yes"
				keys="GEADid"
				maxRows="15"
				formName="lista_anticipos"
				PageIndex="21"
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

            	
		          
