<!--- Parámetros del TAG --->

<cfparam name="Attributes.conexion" 	type="String" default="#session.DSN#">
<cfparam name="Attributes.empresa" 		type="string" default="#session.Ecodigo#">
<cfparam name="Attributes.form" 		type="string" default="form1">
<cfparam name="Attributes.RHAlinea" 	type="numeric">
<cfparam name="Attributes.botonCerrar" 	type="boolean" default="false">

<cfquery name="rsEstructura" datasource="#Attributes.conexion#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.empresa#">
	and CSsalariobase = 1
</cfquery>
<cfset usaEstructuraSalarial = false>
<cfif rsEstructura.recordCount and rsEstructura.CSusatabla EQ 1>
	<cfset usaEstructuraSalarial = true>
</cfif>

<cfquery name="rsAccion" datasource="#Attributes.conexion#">
	select	b.DEidentificacion, 
			{fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) }  as NombreEmp,
		   rtrim(c.RHTcodigo) as RHTcodigo, c.RHTdesc, a.DLfvigencia, a.DLffin
	from RHAcciones a
		 inner join DatosEmpleado b
			on b.DEid = a.DEid
		 inner join RHTipoAccion c
			on c.RHTid = a.RHTid
	where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RHAlinea#">
</cfquery>



<cfquery name="rsEstadoActual" datasource="#Attributes.conexion#">
	select a.LTid, rtrim(a.Tcodigo) as Tcodigo, RHCPlineaP,RHPcodigoAlt,
		   a.RVid, a.Ocodigo, 
		   a.Dcodigo, a.RHPid, 
		   coalesce(ltrim(ltrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo))) as RHPcodigo, a.RHJid,
		   a.LTporcplaza, a.LTporcsal, a.LTsalario,
		   b.Tdescripcion, c.Descripcion as RegVacaciones, d.Odescripcion, e.Ddescripcion, 
		   f.RHPdescripcion, rtrim(f.RHPcodigo) as CodPlaza, coalesce(ltrim(ltrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo))) as CodPuesto, 
		   f.Dcodigo as CodDepto, f.Ocodigo as CodOfic,
		   {fn concat(rtrim(f.RHPcodigo),{fn concat(' - ',f.RHPdescripcion)})} as Plaza, 
		   g.RHPdescpuesto, 
		   {fn concat(rtrim(coalesce(ltrim(ltrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo)))),{fn concat(' - ',g.RHPdescpuesto)})} as Puesto,
		   {fn concat(rtrim(j.RHJcodigo),{fn concat(' - ',j.RHJdescripcion )})} as Jornada,	   
		   a.RHCPlinea,
		   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
		   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
		   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,
           (select 	min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' ',ltrim(rtrim(cf.CFdescripcion)))})})
               from CFuncional cf
                where f.CFid = cf.CFid
                    and f.Ecodigo = cf.Ecodigo		
              )	as Ctrofuncional
	from LineaTiempo a
		 inner join TiposNomina b
			on a.Ecodigo = b.Ecodigo
			and a.Tcodigo = b.Tcodigo
		 inner join RegimenVacaciones c
			on a.RVid = c.RVid
		 inner join Oficinas d
			on a.Ocodigo = d.Ocodigo
			and a.Ecodigo = d.Ecodigo
		 inner join Departamentos e
			on a.Dcodigo = e.Dcodigo
			and a.Ecodigo = e.Ecodigo
		 inner join RHPlazas f
			on a.RHPid = f.RHPid
			and a.Ecodigo = f.Ecodigo
		 inner join RHPuestos g
			on a.RHPcodigo = g.RHPcodigo
			and a.Ecodigo = g.Ecodigo
		 inner join RHJornadas j
			on a.Ecodigo = j.Ecodigo
			and a.RHJid = j.RHJid
		 left outer join RHCategoriasPuesto r
			on r.RHCPlinea = a.RHCPlinea
		 left outer join RHTTablaSalarial s
			on s.RHTTid = r.RHTTid
		 left outer join RHCategoria t
			on t.RHCid = r.RHCid
		 left outer join RHMaestroPuestoP u
			on u.RHMPPid = r.RHMPPid
	where exists (
		select 1
		from RHAcciones acc
		where acc.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RHAlinea#">
		and acc.DLfvigencia between a.LTdesde and a.LThasta
		and acc.DEid = a.DEid
		and acc.RHPid = a.RHPid
	)
</cfquery>

<cfif isdefined('rsEstadoActual') and rsEstadoActual.RecordCount EQ 0>
	<cfquery name="rsEstadoActual" datasource="#Attributes.conexion#">
		select a.LTRid as LTid, rtrim(a.Tcodigo) as Tcodigo, RHCPlineaP,RHPcodigoAlt,
			   a.RVid, a.Ocodigo, 
			   a.Dcodigo, a.RHPid, 
			   coalesce(ltrim(ltrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo))) as RHPcodigo, a.RHJid,
			   a.LTporcplaza, a.LTporcsal, a.LTsalario,
			   b.Tdescripcion, c.Descripcion as RegVacaciones, d.Odescripcion, e.Ddescripcion, 
			   f.RHPdescripcion, rtrim(f.RHPcodigo) as CodPlaza, coalesce(ltrim(ltrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo))) as CodPuesto, 
			   f.Dcodigo as CodDepto, f.Ocodigo as CodOfic,
			   {fn concat(rtrim(f.RHPcodigo),{fn concat(' - ',f.RHPdescripcion)})} as Plaza, 
			   g.RHPdescpuesto, 
			   {fn concat(rtrim(coalesce(ltrim(ltrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo)))),{fn concat(' - ',g.RHPdescpuesto)})} as Puesto,
			   {fn concat(rtrim(j.RHJcodigo),{fn concat(' - ',j.RHJdescripcion )})} as Jornada,	   
			   a.RHCPlinea,
			   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
			   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
			   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,
               (select 	min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' ',ltrim(rtrim(cf.CFdescripcion)))})})
                   from CFuncional cf
                    where f.CFid = cf.CFid
                        and f.Ecodigo = cf.Ecodigo		
                  )	as Ctrofuncional
		from LineaTiempoR a
			 inner join TiposNomina b
				on a.Ecodigo = b.Ecodigo
				and a.Tcodigo = b.Tcodigo
			 inner join RegimenVacaciones c
				on a.RVid = c.RVid
			 inner join Oficinas d
				on a.Ocodigo = d.Ocodigo
				and a.Ecodigo = d.Ecodigo
			 inner join Departamentos e
				on a.Dcodigo = e.Dcodigo
				and a.Ecodigo = e.Ecodigo
			 inner join RHPlazas f
				on a.RHPid = f.RHPid
				and a.Ecodigo = f.Ecodigo
			 inner join RHPuestos g
				on a.RHPcodigo = g.RHPcodigo
				and a.Ecodigo = g.Ecodigo
			 inner join RHJornadas j
				on a.Ecodigo = j.Ecodigo
				and a.RHJid = j.RHJid
			 left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
			 left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid
			 left outer join RHCategoria t
				on t.RHCid = r.RHCid
			 left outer join RHMaestroPuestoP u
				on u.RHMPPid = r.RHMPPid
		where exists (
			select 1
			from RHAcciones acc
			where acc.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RHAlinea#">
			and acc.DLfvigencia between a.LTdesde and a.LThasta
			and acc.DEid = a.DEid
			and acc.RHPid = a.RHPid
		)
	</cfquery>
	
</cfif>

<cfquery name="rsAccion" datasource="#Attributes.conexion#">
	select a.RHAlinea,RHCatParcial,a.RHCPlineaP,RHPcodigoAlt,
		   a.DEid, 
		   a.RHTid, 
		   a.Ecodigo, 
		   a.EcodigoRef, 
		   rtrim(a.Tcodigo) as Tcodigo, 
		   a.RVid, 
		   a.Dcodigo, 
		   a.Ocodigo, 
		   a.RHPid, 
		   coalesce(ltrim(ltrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigo, 
		   a.RHJid,
		   a.DLfvigencia, 
		   a.DLfvigencia as rige,
		   a.DLffin,
		   a.DLffin as vence,
		   a.DLsalario, a.DLobs, a.Usucodigo, a.Ulocalizacion, a.RHAporc, a.RHAporcsal,
		   a.RHAvdisf, a.RHAvcomp, 
		   b.NTIcodigo, b.DEidentificacion,
		   {fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') }, b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
		   rtrim(c.RHTcodigo) as RHTcodigo, c.RHTdesc, c.RHTpfijo, 
		   c.RHTctiponomina, c.RHTcregimenv, c.RHTcoficina, c.RHTcdepto, c.RHTcplaza, c.RHTcpuesto, c.RHTccomp, 
		   c.RHTcsalariofijo, c.RHTcjornada, 1 as RHTcvacaciones, c.RHTccatpaso, c.RHTcempresa, c.RHTnoveriplaza,
		   c.RHTcomportam, c.RHTpmax, 
		   d.NTIdescripcion, a.ts_rversion,
		   e.RHPdescripcion, rtrim(e.RHPcodigo) as CodPlaza, coalesce(ltrim(ltrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as CodPuesto, 
		   e.Dcodigo as CodDepto, e.Ocodigo as CodOfic,
		   f.RHPdescpuesto,
		   g.Tdescripcion, h.Descripcion as RegVacaciones, i.Odescripcion, j.Ddescripcion,
		   {fn concat(rtrim(e.RHPcodigo),{fn concat(' - ', e.RHPdescripcion)})} as Plaza,
		   {fn concat(coalesce(ltrim(ltrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))),{fn concat(' - ',f.RHPdescpuesto)})} as Puesto,
		   {fn concat(rtrim(k.RHJcodigo),{fn concat(' - ',k.RHJdescripcion)})} as Jornada,
		   a.Indicador_de_Negociado as negociado,
		   a.RHCPlinea,
		   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
		   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
		   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,
           				   ( select min( { fn concat( ltrim(rtrim(cf.CFcodigo)), { fn concat(' - ', ltrim(rtrim(cf.CFdescripcion)))} )})
						from CFuncional cf
						where cf.CFid = e.CFid
					) as Ctrofuncional
			,a.RHAid
	from RHAcciones a
		 inner join DatosEmpleado b
			on a.DEid = b.DEid
		 inner join RHTipoAccion c
			on a.RHTid = c.RHTid
		 inner join NTipoIdentificacion d
			on b.NTIcodigo = d.NTIcodigo
			and d.Ecodigo = #session.Ecodigo#
		 left outer join RHPlazas e
			on a.RHPid = e.RHPid
		 left outer join RHPuestos f
			on a.Ecodigo = f.Ecodigo
			and a.RHPcodigo = f.RHPcodigo
		 left outer join TiposNomina g
			on a.Ecodigo = g.Ecodigo
			and a.Tcodigo = g.Tcodigo
		 left outer join RegimenVacaciones h
			on a.RVid = h.RVid
		 left outer join Oficinas i
			on a.Ecodigo = i.Ecodigo
			and a.Ocodigo = i.Ocodigo
		 left outer join Departamentos j
			on a.Ecodigo = j.Ecodigo
			and a.Dcodigo = j.Dcodigo
		 left outer join RHJornadas k
			on a.Ecodigo = k.Ecodigo
			and a.RHJid = k.RHJid
		 left outer join RHCategoriasPuesto r
			on r.RHCPlinea = a.RHCPlinea
		 left outer join RHTTablaSalarial s
			on s.RHTTid = r.RHTTid
		 left outer join RHCategoria t
			on t.RHCid = r.RHCid
		 left outer join RHMaestroPuestoP u
			on u.RHMPPid = r.RHMPPid
	where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RHAlinea#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.empresa#">
</cfquery>

<cfset porcentajeDePlazaAnterior=rsEstadoActual.LTporcplaza>
<cfset porcentajeDePlazaPosterior=rsAccion.RHAporc>

<cfquery name="rsComponentesActual" datasource="#Attributes.conexion#">
	select c.CSid, 
		   c.CScodigo, 
		   c.CSdescripcion,
		   c.CSusatabla,
		   c.CSsalariobase,
		   b.DLTtabla, 
		   coalesce(b.DLTunidades, 1.00) as DLTunidades, 
		   case 
				when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2) * 100
				else round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2)
		   end as DLTmontobase,
                case  
					when coalesce(c.CIid, -1) = -1 and c.CSusatabla <> 0
						then coalesce(b.DLTmonto,0.00) * #porcentajeDePlazaAnterior# /100
					else
						coalesce(b.DLTmonto,0.00)
				end as DLTmonto,

		   coalesce(c.CIid, -1) as CIid,
		   coalesce(d.RHMCcomportamiento, 1) as RHMCcomportamiento,
		   coalesce(d.RHMCvalor, 1.00) as valor,
		   coalesce(b.DRCid,0) as DRCid
	from DLineaTiempo b
		 inner join ComponentesSalariales c
			on c.CSid = b.CSid
		 left outer join RHMetodosCalculo d
			on d.Ecodigo = c.Ecodigo
			and d.CSid = c.CSid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between d.RHMCfecharige and d.RHMCfechahasta
			and d.RHMCestadometodo = 1
	where b.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
	order by 2, 3
</cfquery>

<!--- SI EXISTE UN PUESTO ALTERNO SE TIENE QUE MOSTRAR LA INFORMACION --->
 <cfif LEN(TRIM(rsEstadoActual.RHPcodigoAlt))>
	<cfquery name="rsPuestoAlternoAct" datasource="#session.DSN#">
		select c.RHTTid as RHTTid2,a.RHMPPid as RHMPPid2,c.RHCid as RHCid2,
				c.RHTTid as RHTTid5,a.RHMPPid as RHMPPid5,c.RHCid as RHCid5,RHCPlinea,RHTTcodigo,RHTTdescripcion,RHMPPcodigo,RHMPPdescripcion,
				RHCcodigo,RHCdescripcion,<cf_dbfunction name="concat" args="RHPcodigo,' - ',RHPdescpuesto"> as puesto,
				RHPcodigo
		from RHPuestos a
		inner join RHMaestroPuestoP b
			on b.RHMPPid = a.RHMPPid
			and b.Ecodigo = a.Ecodigo
		inner join RHCategoriasPuesto c
			on c.RHMPPid = b.RHMPPid
			and c.Ecodigo = b.Ecodigo
		inner join RHTTablaSalarial ts
			on ts.RHTTid = c.RHTTid
		inner join RHVigenciasTabla vt
			on vt.RHTTid = ts.RHTTid
		inner join RHCategoria cat
			on cat.RHCid = c.RHCid
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEstadoActual.RHPcodigoAlt#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between vt.RHVTfecharige and vt.RHVTfechahasta
	</cfquery>
</cfif>

	<cfset Lvar_PuestoAlt = ''>
    <cfif LEN(TRIM(rsAccion.RHPid)) and LEN(TRIM(rsAccion.RHPcodigoAlt))>
        <cfset Lvar_PuestoAlt = rsAccion.RHPcodigoAlt>
    <cfelseif  not LEN(TRIM(rsAccion.RHPid)) and LEN(TRIM(rsEstadoActual.RHPcodigoAlt))>
        <cfset Lvar_PuestoAlt = rsEstadoActual.RHPcodigoAlt>
    </cfif>
    <cfif LEN(TRIM(Lvar_PuestoAlt))>
        <cfquery name="rsPuestoAlterno" datasource="#session.DSN#">
            select c.RHTTid as RHTTid2,a.RHMPPid as RHMPPid2,c.RHCid as RHCid2,
                    c.RHTTid as RHTTid5,a.RHMPPid as RHMPPid5,c.RHCid as RHCid5,RHCPlinea,RHTTcodigo,RHTTdescripcion,RHMPPcodigo,RHMPPdescripcion,
                    RHCcodigo,RHCdescripcion,<cf_dbfunction name="concat" args="RHPcodigo,' - ',RHPdescpuesto"> as puesto,
                    RHPcodigo
            from RHPuestos a
            inner join RHMaestroPuestoP b
                on b.RHMPPid = a.RHMPPid
                and b.Ecodigo = a.Ecodigo
            inner join RHCategoriasPuesto c
                on c.RHMPPid = b.RHMPPid
                and c.Ecodigo = b.Ecodigo
            inner join RHTTablaSalarial ts
                on ts.RHTTid = c.RHTTid
            inner join RHVigenciasTabla vt
                on vt.RHTTid = ts.RHTTid
            inner join RHCategoria cat
                on cat.RHCid = c.RHCid
            where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_PuestoAlt#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between vt.RHVTfecharige and vt.RHVTfechahasta
        </cfquery>
    </cfif>

<cfif isdefined('rsComponentesActual') and rsComponentesActual.RecordCount EQ 0>
	<cfquery name="rsComponentesActual" datasource="#Attributes.conexion#">
		select c.CSid, 
			   c.CScodigo, 
			   c.CSdescripcion,
			   c.CSusatabla,
			   c.CSsalariobase,
			   b.DLTtabla, 
			   coalesce(b.DLTunidades, 1.00) as DLTunidades, 
			   case 
					when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2) * 100
					else round(coalesce(b.DLTmonto, 0.00) / coalesce(b.DLTunidades, 1.00), 2)
			   end as DLTmontobase,
                case 
					when coalesce(c.CIid, -1) = -1 and c.CSusatabla <> 0
						then coalesce(b.DLTmonto,0.00) * #porcentajeDePlazaAnterior# /100
					else
						coalesce(b.DLTmonto,0.00)
				end as DLTmonto,
			   coalesce(c.CIid, -1) as CIid,
			   coalesce(d.RHMCcomportamiento, 1) as RHMCcomportamiento,
			   coalesce(d.RHMCvalor, 1.00) as valor,
			   coalesce(b.DRCid,0) as DRCid
		from DLineaTiempoR b
			 inner join ComponentesSalariales c
				on c.CSid = b.CSid
			 left outer join RHMetodosCalculo d
				on d.Ecodigo = c.Ecodigo
				and d.CSid = c.CSid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between d.RHMCfecharige and d.RHMCfechahasta
				and d.RHMCestadometodo = 1
		where b.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
		order by 2, 3
	</cfquery>
</cfif>

<cfquery name="rsSumComponentesActual" dbtype="query">
	select sum(DLTmonto) as Total from rsComponentesActual
</cfquery>

<cfquery name="rsComponentesAccion" datasource="#Attributes.conexion#">
	select a.RHDAlinea, 
		   a.CSid, 
		   b.CSdescripcion, 
		   b.CSusatabla,
		   b.CSsalariobase,
		   a.RHDAtabla, 
		   a.RHDAunidad, 
		   a.RHDAmontobase, 
            case 
                when coalesce(b.CIid, -1) = -1 and b.CSusatabla <> 0
                    then coalesce(a.RHDAmontores,0.00) * #porcentajeDePlazaPosterior# /100
                else
                    coalesce(a.RHDAmontores,0.00)
            end as RHDAmontores,
		   a.ts_rversion,
		   coalesce(b.CIid, -1) as CIid,
		   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento,
		   coalesce(c.RHMCvalor, 1.00) as valor,
		   coalesce(a.DRCid,0) as DRCid
	from RHDAcciones a
		 inner join RHAcciones acc
		 	on acc.RHAlinea = a.RHAlinea
		 inner join ComponentesSalariales b 
			on b.CSid = a.CSid
		 left outer join RHMetodosCalculo c
			on c.Ecodigo = b.Ecodigo
			and c.CSid = b.CSid
			and acc.DLfvigencia between c.RHMCfecharige and c.RHMCfechahasta
			and c.RHMCestadometodo = 1
	where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RHAlinea#">
	order by b.CScodigo, b.CSdescripcion
</cfquery>

<cfquery name="rsSumComponentesAccion" dbtype="query">
	select sum(RHDAmontores) as Total from rsComponentesAccion
</cfquery>

<cfquery name="rsConceptosPago" datasource="#Session.DSN#">
	select {fn concat(b.CIcodigo,{fn concat(' - ',b.CIdescripcion)})} as Concepto, 
		   a.RHCAimporte as Importe, 
		   a.RHCAcant as Cantidad, 
		   a.RHCAres as Resultado,
		   b.CIid,a.RHAlinea
	from RHConceptosAccion a, CIncidentes b
	where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
	and a.CIid = b.CIid
</cfquery>

<!----=================== TRADUCCION =====================---->
<cfinvoke Key="BTN_Cerrar" Default="Cerrar" returnvariable="BTN_Cerrar"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ListaPuestosAlternos" default="Lista de Puestos Alternos"	 returnvariable="LB_ListaPuestosAlternos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros"	 returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<!------------------------------------------ ENCABEZADO DE ACCION ------------------------------------------>
	  <tr>
	  	<td colspan="2">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
			  <tr>
				<td height="22" width="10%" align="right" class="fileLabel" nowrap><cf_translate key="LB_Empleado">Empleado:</cf_translate></td>
				<td colspan="5" nowrap><strong>#rsAccion.DEidentificacion#</strong>&nbsp;&nbsp;#rsAccion.NombreEmp#</td>
			  </tr>
			  <tr>
				<td height="22" align="right" class="fileLabel" nowrap><cf_translate key="LB_Tipo_de_accion">Tipo de Acci&oacute;n:</cf_translate></td>
				<td nowrap><strong>#rsAccion.RHTcodigo#</strong>&nbsp;&nbsp;#rsAccion.RHTdesc#</td>
				<td align="right" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Rige">Fecha Rige:</cf_translate></td>
				<td nowrap>#LSDateFormat(rsAccion.DLfvigencia,'DD/MM/YYYY')#</td>
				<td align="right" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Vence">Fecha Vence:</cf_translate></td>
				<td nowrap><cfif Len(Trim(rsAccion.DLffin))>#LSDateFormat(rsAccion.DLffin,'DD/MM/YYYY')#<cfelse>&nbsp;</cfif></td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<!------------------------------------------ SITUACION ACTUAL ------------------------------------------>
		<td width="50%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid gray;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual</cf_translate></div></td>
			  </tr>
			  <tr>
			  	<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
                      <tr>
                        <td height="25" class="fileLabel" nowrap><cf_translate key="LB_Empresa"><strong>Empresa</strong></cf_translate></td>
                        <td height="25" nowrap>#Session.Enombre#</td>
                      </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap>
						  <cf_translate key="LB_Plaza"><strong>Plaza</strong></cf_translate></td>
						<td height="25" nowrap>#rsEstadoActual.Plaza#</td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Oficina"><strong>Oficina</strong></cf_translate></td>
                          
						<td height="25" nowrap>#rsEstadoActual.Odescripcion#</td>
						</tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap>
						  <cf_translate key="LB_Departamento"><strong>Departamento</strong></cf_translate></td>
						<td height="25" nowrap>#rsEstadoActual.Ddescripcion#</td>
						</tr>
					  <tr>
                        <td height="25" class="fileLabel" nowrap>
                          <cf_translate key="LB_Centro_Funcional"><strong>Centro Funcional</strong></cf_translate></td>
                        <td>#rsEstadoActual.Ctrofuncional#</td>
                      </tr>
					  <cfif usaEstructuraSalarial EQ 1>
						  <cf_rhcategoriapuesto form="form1" query="#rsEstadoActual#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
					  </cfif>
					  <cfif usaEstructuraSalarial EQ 1 and LEN(TRIM(rsEstadoActual.RHCPlineaP)) and rsEstadoActual.RHCPlineaP Gt 0>
                            <cfif rsEstadoActual.RHCPlineaP EQ 0>
                                <cfset Lvar_CatPropM= false>
                            <cfelse>
                                <cfset Lvar_CatPropM= true>
                            </cfif>
                      
                        <cfquery name="rsCatProp" datasource="#session.DSN#">
                            select RHTTid as RHTTid6, RHMPPid as RHMPPid6, a.RHCid as RHCid6, RHCcodigo as RHCcodigo6
                            from RHCategoriasPuesto a
                            inner join RHCategoria b
                                on b.RHCid = a.RHCid
                            where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHCPlineaP#">
                        </cfquery>
                      <tr>
                        <td align="center" colspan="2" class="titulo" ><strong>Puesto-Categoría Propuesta</strong></td>
                        <td height="25" nowrap>
                            <cf_rhcategoriapuesto form="form1" query="#rsCatProp#" 
                            tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" Ecodigo="#session.Ecodigo#"
                            index="6">
                        </td>
                        </tr>
                      </cfif>
					  <tr>
						<td height="25" class="fileLabel" nowrap>
						  <cf_translate key="LB_Puesto"><strong>Puesto RH</strong></cf_translate></td>
						<td height="25" nowrap>#rsEstadoActual.Puesto#</td>
						</tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap>
						  <cf_translate key="LB_Jornada"><strong>Jornada</strong></cf_translate></td>
						<td height="25" nowrap>#rsEstadoActual.Jornada#</td>
						</tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap>
						  <cf_translate key="LB_Porcentaje_de_plaza"><strong>Porcentaje de Plaza</strong></cf_translate></td>
						<td height="25" nowrap><cfif rsEstadoActual.LTporcplaza NEQ "">#LSCurrencyFormat(rsEstadoActual.LTporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap>
						  <cf_translate key="LB_Porcentaje_de_salario_fijo"><strong>Porcentaje de Salario Fijo</strong></cf_translate></td>
						<td height="25" nowrap><cfif rsEstadoActual.LTporcsal NEQ "">#LSCurrencyFormat(rsEstadoActual.LTporcsal,'none')# %<cfelse>0.00 %</cfif></td>
					  </tr>
                      <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Tipo_de_nomina"><strong>Tipo de N&oacute;mina</strong></cf_translate></td>
						<td height="25" nowrap>#rsEstadoActual.Tdescripcion#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Regimen_de_Vacaciones"><strong>R&eacute;gimen de Vacaciones</strong></cf_translate></td>
						<td height="25" nowrap>#rsEstadoActual.RegVacaciones#</td>
					  </tr>
					  <cfif rsAccion.RHTcomportam EQ 3>
					  <tr>
						<td height="25" class="fileLabel" nowrap>&nbsp;</td>
						<td height="25" nowrap>&nbsp;</td>
						</tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap>&nbsp;</td>
						<td height="25" nowrap>&nbsp;</td>
						</tr>
					  </cfif>
                    <cfif usaEstructuraSalarial EQ 1 and isdefined('rsPuestoAlternoAct') and rsPuestoAlternoAct.RecordCount GT 0>	
                        <tr bgcolor="CCCCCC" height="25"><td colspan="2" align="center"><strong><cf_translate key="LB_PuestoAlterno">Puesto Alterno</cf_translate></strong></td></tr>
                        <tr>
                            <td height="25" class="fileLabel" nowrap><strong><cf_translate key="LB_Puesto_RH">Puesto RH</cf_translate></strong></td>
                            <td height="25" nowrap>#rsPuestoAlternoAct.Puesto#</td>
                        </tr>
                        
                        <cf_rhcategoriapuesto form="form1" query="#rsPuestoAlternoAct#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" 		
                            incluyeHiddens="false" index="2">
                    </cfif>	  

					</table>
				</td>
			  </tr>
			</table>
		</td>
		<!---------------------------------------- SITUACION PROPUESTA ----------------------------------------->
		<td width="50%" valign="top">

			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid gray;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td>
			  </tr>
			  <tr>
			  	<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
                      <tr>
                        <td height="25" class="fileLabel" nowrap>
                          <cf_translate key="LB_Empresa"><strong>Empresa</strong></cf_translate></td>
                        <td height="25" nowrap>#Session.Enombre#</td>
                      </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Plaza"><strong>Plaza</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.Plaza#</td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Oficina"><strong>Oficina</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.Odescripcion# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Departamento"><strong>Departamento</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.Ddescripcion#</td>
					  </tr>
					  <tr>
                        <td height="25" class="fileLabel" nowrap>
                          <cf_translate key="LB_Centro_Funcional"><strong>Centro Funcional</strong></cf_translate></td>
                        <td>#rsAccion.Ctrofuncional#</td>
                      </tr>
					  <cfif usaEstructuraSalarial EQ 1>
						<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
					  </cfif>
					   <cfif  rsAccion.RHCatParcial GT 0 or (Len(Trim(rsAccion.RHCPlineaP)) GT 0 and rsAccion.RHCPlineaP GT 0)>
                            <tr><td align="center" colspan="2" class="titulo" ><strong>Puesto-Categoría Propuesta</strong></td></tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
                                <td colspan="2">
                                    <cfquery name="rsAcciones" datasource="#session.dsn#">
                                        select RHCatParcial from RHTipoAccion where RHTid=#rsAccion.RHTid#
                                    </cfquery>
                                    <cfif rsAcciones.RHCatParcial EQ 0>
                                        <cfset Lvar_CatPropM= true>
                                    <cfelse>
                                        <cfset Lvar_CatPropM= false>
                                    </cfif>
                                    <cfset emp = Session.Ecodigo>
                                    <!--- En caso de Cambio de Empresa --->
                                    <cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
                                        <cfset emp = rsAccion.EcodigoRef>
                                    </cfif>
                                    <cfif Len(Trim(rsAccion.RHCPlineaP))>			 
                                        <cfquery name="rsCatProp" datasource="#session.DSN#">
                                            select RHTTid as RHTTid4, RHMPPid as RHMPPid4, a.RHCid as RHCid4, RHCcodigo as RHCcodigo4
                                            from RHCategoriasPuesto a
                                            inner join RHCategoria b
                                                on b.RHCid = a.RHCid
                                            where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHCPlineaP#">
                                        </cfquery>
                                        <!--- <cf_dump var="#rsCatProp#"> --->
                                        <cf_rhcategoriapuesto form="form1" query="#rsCatProp#" 
                                        tablaReadonly="#Lvar_CatPropM#" categoriaReadonly="#Lvar_CatPropM#" puestoReadonly="#Lvar_CatPropM#" incluyeTabla="false" Ecodigo="#emp#"
                                        index="4">
                                     <cfelseif Len(Trim(rsEstadoActual.RHCPlineaP))>			 
                                        <cfquery name="rsCatProp" datasource="#session.DSN#">
                                            select RHTTid as RHTTid4, RHMPPid as RHMPPid4, a.RHCid as RHCid4, RHCcodigo as RHCcodigo4
                                            from RHCategoriasPuesto a
                                            inner join RHCategoria b
                                                on b.RHCid = a.RHCid
                                            where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHCPlineaP#">
                                        </cfquery>
                                        <!--- <cf_dump var="#rsCatProp#"> --->
                                        <cf_rhcategoriapuesto form="form1" query="#rsCatProp#" 
                                        tablaReadonly="#Lvar_CatPropM#" categoriaReadonly="#Lvar_CatPropM#" puestoReadonly="#Lvar_CatPropM#" incluyeTabla="false" Ecodigo="#emp#"
                                        index="4">
                                    <cfelse>
                                        <cf_rhcategoriapuesto form="form1" tablaReadonly="false" 
                                        incluyeTabla="false" Ecodigo="#emp#" index="4">
                                    </cfif>
                                </td>
                            </tr>
                      </cfif>

					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Puesto"><strong>Puesto RH</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.Puesto# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Jornadas"><strong>Jornada</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.Jornada#</td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Porcentaje_de_Plaza"><strong>Porcentaje de Plaza</strong></cf_translate></td>
						<td height="25" nowrap><cfif rsAccion.RHAporc NEQ "">#LSCurrencyFormat(rsAccion.RHAporc,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap>
						  <cf_translate key="LB_Porcentaje_de_Salario_Fijo"><strong>Porcentaje de Salario Fijo</strong></cf_translate></td>
						<td height="25" nowrap><cfif rsAccion.RHAporcsal NEQ "">#LSCurrencyFormat(rsAccion.RHAporcsal,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Tipo_de_Nomina"><strong>Tipo de N&oacute;mina</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.Tdescripcion#</td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Regimen_de_Vacaciones"><strong>R&eacute;gimen de Vacaciones</strong></cf_translate></td>
						<td height="25" nowrap>#rsAccion.RegVacaciones# </td>
					  </tr>
					  <cfif rsAccion.RHTcomportam EQ 3>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Vacaciones_disfrutadas"><strong>Vacaciones disfrutadas</strong></cf_translate></td>
						<td height="25" nowrap>
							<cfif Len(Trim(rsAccion.RHAvdisf))>#LSCurrencyFormat(rsAccion.RHAvdisf,'none')#<cfelse>&nbsp;</cfif>
						</td>
						</tr>
						<!---- 20131001 fcastro. Este desarrollo se comenta hasta encontrar la funcionalidad completa de los días compensados
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Vacaciones_Compensadas"><strong>Vacaciones compensadas</strong></cf_translate></td>
						<td height="25" nowrap>
							<cfif Len(Trim(rsAccion.RHAvcomp))>#LSCurrencyFormat(rsAccion.RHAvcomp,'none')#<cfelse>&nbsp;</cfif>
						</td>
						</tr>
						------>
					  </cfif>
                      
                      
					<cfif usaEstructuraSalarial EQ 1 and ((isdefined('rsPuestoAlterno') and rsPuestoAlterno.RecordCount GT 0) and  (rsAccion.RHTcomportam EQ 1 or rsAccion.RHTcomportam EQ 6 or rsAccion.RHTcomportam EQ 12 or len(rsAccion.RHPcodigoAlt) GT 0))>	
                        <tr bgcolor="CCCCCC" height="25"><td colspan="2" align="center"><strong><cf_translate key="LB_PuestoAlterno">Puesto Alterno</cf_translate></strong></td></tr>
                        <tr>
                            <td height="25" class="fileLabel" nowrap><strong><cf_translate key="LB_Puesto_RH">Puesto RH</cf_translate></strong></td>
                            <td height="25" nowrap>
                                <cfset ArrayPuesto=''>
                                <cfif isdefined('rsPuestoAlterno') and rsPuestoAlterno.RHPcodigo GT 0>
                                    <cfquery name="rsPuesto" datasource="#session.DSN#">
                                        select RHPcodigo,RHPdescpuesto,<cf_dbfunction name="concat" args="RHPcodigo,' - ',RHPdescpuesto"> as puesto
                                        from RHPuestos 
                                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                          and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPuestoAlterno.RHPcodigo#">
                                    </cfquery>
                                    <cfset ArrayPuesto='#rsPuesto.RHPcodigo#,#rsPuesto.RHPdescpuesto#'>
                                </cfif>
                                #rsPuesto.Puesto#
                            </td>
                        </tr>
                        <cfif isdefined('rsPuestoAlterno')>
                            <cf_rhcategoriapuesto form="form1" query="#rsPuestoAlterno#" tablaReadonly="true" 
                            categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false"
                            index="5">
                        <cfelse>
                        <cf_rhcategoriapuesto form="form1" tablaReadonly="true" 
                        categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false"
                        index="5">
                        
                        </cfif>
                    </cfif>	  		
					</table>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<!---------------------------------------- COMPONENTES ACTUALES ---------------------------------------->
		<td valign="top">

			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid gray;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Componentes_Actuales">Componentes Actuales</cf_translate></div></td>
			  </tr>
			  <tr>
			  	<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td>
							<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
								<cfinvokeargument name="query" value="#rsComponentesActual#">
								<cfinvokeargument name="totalComponentes" value="#rsSumComponentesActual.Total#">
								<cfinvokeargument name="permiteAgregar" value="false">
								<cfinvokeargument name="readonly" value="true">
								<cfinvokeargument name="incluyeHiddens" value="false">
								<cfinvokeargument name="unidades" value="DLTunidades">
								<cfinvokeargument name="montobase" value="DLTmontobase">
								<cfinvokeargument name="montores" value="DLTmonto">
							</cfinvoke>
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
			</table>
		
		</td>
		<!-------------------------------------- COMPONENTES PROPUESTOS --------------------------------------->
		<td valign="top">

			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid gray;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Componentes_Propuestos">Componentes Propuestos</cf_translate></div></td>
			  </tr>
			  <tr>
			  	<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
					  <tr> 
						<td>
							<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
								<cfinvokeargument name="query" value="#rsComponentesAccion#">
								<cfinvokeargument name="totalComponentes" value="#iif(LEN(TRIM(rsSumComponentesAccion.Total)),rsSumComponentesAccion.Total,0)#">
								<cfinvokeargument name="permiteAgregar" value="false">
								<cfinvokeargument name="readonly" value="true">
								<cfinvokeargument name="incluyeHiddens" value="false">
							</cfinvoke>
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
			</table>
		
		</td>
	  </tr>
      <tr>
        <td align="center" colspan="2" style="color: ##FF0000; border: 1px solid black;">
			<cf_translate key="LB_Los_componentes_que_aparecen_en_color_rojo_se_pagan_en_forma_reincidente">Los componentes que aparecen en color rojo se pagan en forma incidente.</cf_translate>
		</td>
      </tr>
	  
	<!-------------------------------------- CONCEPTOS DE PAGO --------------------------------------->
	  <cfif isdefined("rsConceptosPago") and rsConceptosPago.recordCount GT 0>
	  <tr>
	  	<td colspan="2">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid gray;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Conceptos_de_pago">Conceptos de Pago</cf_translate></div></td>
			  </tr>
			  <tr>
			  	<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td height="22" class="tituloListas" nowrap><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
						<td class="tituloListas" align="right" nowrap><cf_translate key="LB_Importe">Importe</cf_translate></td>
						<td class="tituloListas" align="right" nowrap><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
						<td class="tituloListas" align="right" nowrap><cf_translate key="LB_Resultado">Resultado</cf_translate></td>
					  </tr>
		
					  <cfloop query="rsConceptosPago">
						  <tr>
							<td height="22" nowrap>#rsConceptosPago.Concepto#</td>
							<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Importe, 'none')#</td>
							<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Cantidad, 'none')#</td>
							<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Resultado, 'none')#</td>
							<td align="right" nowrap>
			                    <img src="/cfmx/rh/imagenes/Magnifier.gif" onclick="mostrarCalculo(#rsConceptosPago.CIid#,#rsConceptosPago.RHAlinea#)">
			                </td>



						  </tr>
					  </cfloop>
					</table>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  </cfif>
	</table>
</cfoutput>

<cfif Attributes.botonCerrar>
	<p align="center">
		<cfoutput><input type="button" value="#BTN_Cerrar#" onclick="javascript: window.close();" /></cfoutput>
	</p>
</cfif>


	<script>
	var popUpWin=0;
	function popUpWindow(URLStr, width, height){
		var left = ((screen.width/2)-(width/2)); 
		var top=((screen.height/2)-(height/2)); 
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function mostrarCalculo(CIid,RHAlinea) {
			popUpWindow("/cfmx/rh/nomina/operacion/popUpReporteConceptosPago.cfm?CIid="+CIid+"&RHAlinea="+RHAlinea+"&ModoPopUp=1",600,400);
	}
	</script>