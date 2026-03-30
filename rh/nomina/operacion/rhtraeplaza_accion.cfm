<cfif isdefined("url.codigo") and Len(Trim(url.codigo)) and isdefined("url.fechaAcc") and Len(Trim(url.fechaAcc)) and isdefined("url.empresa") and len(trim(url.empresa))>
	<cfif isdefined ('url.index') and len(trim(url.index)) gt 0>
        <cfset Lvarid=ltrim(rtrim(url.index))>
    <cfelse>
        <cfset Lvarid=''>
    </cfif>
	<cfset vd_fechafinal = '01/01/6100'>
	<cfif isdefined("url.fechafinAcc") and Len(Trim(url.fechafinAcc))>
		<cfset vd_fechafinal = url.fechafinAcc>
	</cfif>
	<cfquery name="rs" datasource="#session.DSN#">
				select 	ltp.RHPPid,
				pp.RHPPdescripcion,
				ltrim(rtrim(pp.RHPPcodigo)) as RHPPcodigo,
				ltp.RHCid,
				ltrim(rtrim(ca.RHCcodigo)) as RHCcodigo,
				ca.RHCdescripcion,
				ltp.RHTTid,				
				ts.RHTTdescripcion,
				ts.RHTTcodigo,
				ltp.RHPid,
				ltrim(rtrim(a.RHPcodigo)) as RHPcodigo,
				{fn concat(ltrim(rtrim(a.RHPcodigo)),{fn concat('-',a.RHPdescripcion)})} as RHPdescripcion,
				coalesce(ltrim(rtrim(b.RHPcodigoext)),ltrim(rtrim(b.RHPcodigo))) as RHPpuestoext,
				ltrim(rtrim(b.RHPcodigo)) as RHPpuesto,
				cf.CFid,
				{fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' - ',ltrim(rtrim(cf.CFdescripcion)))})} as CFuncional,
				cf.Ocodigo,
				c.Odescripcion,
				cf.Dcodigo,
				d.Ddescripcion,
				mp.RHMPPid,
				ltrim(rtrim(mp.RHMPPcodigo)) as RHMPPcodigo,
				mp.RHMPPdescripcion,
				b.RHPdescpuesto,
				(select 100.00 - coalesce(sum(z.LTporcplaza), 0.00)
				from LineaTiempo z
				where a.RHPid = z.RHPid 
					and a.Ecodigo = z.Ecodigo 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaAcc)#"> between z.LTdesde and z.LThasta 	
				 ) as Disponible,
				 ltp.RHMPnegociado														

		from RHLineaTiempoPlaza ltp
			
			inner join CFuncional cf
				on ltp.CFidautorizado = cf.CFid		
		
				inner join Oficinas c 
					on cf.Ocodigo = c.Ocodigo 
					and cf.Ecodigo = c.Ecodigo 
	
				inner join Departamentos d 
					on cf.Dcodigo = d.Dcodigo 
					and cf.Ecodigo = d.Ecodigo  
			
			left outer join RHTTablaSalarial ts
				on ltp.RHTTid = ts.RHTTid
				
			left outer join RHCategoria ca
				on ltp.RHCid = ca.RHCid
				
			inner join RHPlazas a
				on ltp.RHPid = a.RHPid
				and a.RHPactiva = 1	
										
				left outer join RHPuestos b 
					on a.RHPpuesto = b.RHPcodigo 
					and a.Ecodigo = b.Ecodigo 
					and b.RHPactivo = 1 
				
			inner join RHPlazaPresupuestaria pp
				on ltp.RHPPid = pp.RHPPid
			
				left outer join RHMaestroPuestoP mp
					on ltp.RHMPPid = mp.RHMPPid
						
		where <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaAcc)#"> between RHLTPfdesde and RHLTPfhasta
			and ltp.RHMPestadoplaza = 'A'
			and rtrim(ltrim(upper(pp.RHPPcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.codigo))#">
			and ltp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
						
		<cfif Url.vfyplz EQ 0 and isdefined("url.DEid") and len(trim(url.DEid))>
			
			and (exists  (	select 1
						 	from LineaTiempo lt
							where a.RHPid = lt.RHPid 
								and a.Ecodigo = lt.Ecodigo 
								and 
								(<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaAcc)#"> between lt.LTdesde and lt.LThasta) 
							having coalesce(sum(lt.LTporcplaza), 0) < 100 )
                    or exists  (	select 1
						 	from LineaTiempo lt
							where a.RHPid = lt.RHPid 
								and a.Ecodigo = lt.Ecodigo 
								and 
								(<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(vd_fechafinal)#"> between lt.LTdesde and lt.LThasta) 
							having coalesce(sum(lt.LTporcplaza), 0) < 100 )
					/*Verifica que la ocupacion de la plaza sea del empleado y en la fecha de la accion*/
					or  exists	( select 1
								from LineaTiempo lt
								where a.RHPid = lt.RHPid 
									and a.Ecodigo = lt.Ecodigo
									and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
									and 
									(<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaAcc)#"> between lt.LTdesde and lt.LThasta 
									 or <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(vd_fechafinal)#"> between lt.LTdesde and lt.LThasta) 
									)		
					)
			
		</cfif>			
	</cfquery>

	<script language="JavaScript">
		<cfoutput>						
		//Plaza presupuestaria
		parent.document.#Url.form#.RHPPcodigo.value = "#Trim(rs.RHPPcodigo)#";
		parent.document.#Url.form#.RHPPdescripcion.value = "#Trim(rs.RHPPdescripcion)#";
		parent.document.#Url.form#.RHPPid.value = "#rs.RHPPid#";
		//Plaza de RH
		parent.document.#Url.form#.RHPid.value = "#rs.RHPid#";
		//Oficina
		parent.document.#Url.form#.Ocodigo.value = "#rs.Ocodigo#";
		parent.document.#Url.form#.Odescripcion.value = "#rs.Odescripcion#";
		//Departamento
		parent.document.#Url.form#.Dcodigo.value = "#rs.Dcodigo#";
		parent.document.#Url.form#.Ddescripcion.value = "#rs.Ddescripcion#";
		//Puesto de RH
		parent.document.#Url.form#.RHPcodigo.value = "#Trim(rs.RHPpuesto)#";	
		parent.document.#Url.form#.RHPcodigoext.value = "#Trim(rs.RHPpuestoext)#";		
		parent.document.#Url.form#.RHPdescpuesto.value = "#Trim(rs.RHPdescpuesto)#";
		//Centro funcional
		parent.document.#Url.form#.CFuncional.value = "#Trim(rs.CFuncional)#";
		<cfif isdefined("url.usaEstructuraSalarial")>
			<!--- var conlispuesto = parent.document.getElementById("imgRHMPPcodigo");			
			var conliscategoria = parent.document.getElementById("imgRHCcodigo"); --->
			//Tabla
			parent.document.#Url.form#.RHTTid#Lvarid#.disabled = false;
			//Puesto Presup
			<!--- conlispuesto.style.display = '';	 --->		
			parent.document.#Url.form#.RHMPPcodigo#Lvarid#.disabled = false;
			//Categoria
			<!--- conliscategoria.style.display = '';	 --->		
			parent.document.#Url.form#.RHCcodigo#Lvarid#.disabled = false;
			//Tabla salarial
			parent.document.#Url.form#.RHTTid#Lvarid#.value = "#rs.RHTTid#";
			parent.document.#Url.form#.RHTTcodigo#Lvarid#.value = "#rs.RHTTcodigo#";
			parent.document.#Url.form#.RHTTdescripcion#Lvarid#.value = "#rs.RHTTdescripcion#";
			//Puesto presupuestario
			parent.document.#Url.form#.RHMPPid#Lvarid#.value = "#rs.RHMPPid#";
			parent.document.#Url.form#.RHMPPcodigo#Lvarid#.value = "#rs.RHMPPcodigo#";
			parent.document.#Url.form#.RHMPPdescripcion#Lvarid#.value = "#Trim(rs.RHMPPdescripcion)#";
			//Categoria
			parent.document.#Url.form#.RHCid#Lvarid#.value = "#rs.RHCid#";
			parent.document.#Url.form#.RHCcodigo#Lvarid#.value = "#rs.RHCcodigo#";
			parent.document.#Url.form#.RHCdescripcion#Lvarid#.value = "#rs.RHCdescripcion#";		
		</cfif>
				
		<cfif rs.recordCount>
		if (parent.document.#url.form#.LTporcplaza) {
			<cfif Url.vfyplz EQ 0>
			if (#rs.Disponible# > 0) {
				parent.document.#url.form#.LTporcplaza.value = "#LSNumberFormat(rs.Disponible, ',9.00')#";
			} else {
				parent.document.#url.form#.LTporcplaza.value = "0.00";
			}
			<cfelse>
				parent.document.#url.form#.LTporcplaza.value = "100.00";
			</cfif>
		}
		<cfelse>
		if (parent.document.#url.form#.LTporcplaza) {
			parent.document.#url.form#.LTporcplaza.value = "0.00";
		}
		</cfif>
		</cfoutput>
	</script>
</cfif>