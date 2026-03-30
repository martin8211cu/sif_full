<cfsetting requesttimeout="8600">

<!--- ELIMINA LOS PARTICIPANTES --->
<cfif isdefined('form.BTNEliminar')>
	<cfset LISTACHK = ListToArray(FORM.CHK)>
	<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
		<cfset data = ListToArray(LISTACHK[i],'|')>
		<cfset form.RHCid = data[1]>
        <cfquery datasource="#session.DSN#">
        	delete RHEmpleadosporCurso
            where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[1]#">
              and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
        </cfquery>
    </cfloop>
<cfelseif isdefined('form.EnviarEmail')>
    <cfquery name="rsDatos" datasource="#session.dsn#">
        select b.DEid,c.DEsexo,c.DEapellido1,c.DEapellido2,c.DEnombre,c.DEemail
	        ,a.RHCid,a.RHCcodigo as Ccodigo ,a.RHCnombre as Cdescripcion,coalesce(a.duracion,0) as Cduracion, a.lugar as Clugar
            ,a.RHCfdesde as CFinicio,a.RHCfhasta as CFfinal,a.horaini as CHincio,a.horafin as CHfin
        from RHCursos a
        inner join RHEmpleadosporCurso b
    	    on a.RHCid = b.RHCid
            and coalesce(b.RHECnotificado,0) = 0
        inner join DatosEmpleado c
    	    on c.DEid = b.DEid
        where a.RHCid = #form.RHCid#
    </cfquery>

	<cfset FromEmail = "capacitacion@soin.co.cr">

	<cfquery name="CuentaPortal"   datasource="asp">
		Select valor
		from  PGlobal
		Where parametro='correo.cuenta'
	</cfquery>
	<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
		<cfset FromEmail = CuentaPortal.valor>
	</cfif>

    <cfloop query="rsDatos">
        <cfsavecontent variable="email_body">
                <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
                <html>
                <head>
                <title>Desarrollo Humano: Programaci�n de Curso</title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                <style type="text/css">
                <!--
                .style1 {
                    font-size: 10px;
                    font-family: "Times New Roman", Times, serif;
                }
                .style2 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-weight: bold;
                    font-size: 14;
                }
                .style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
                .style8 {font-size: 14}
                -->
                </style>
                </head>

                <body>

                    <cfoutput>
                        <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
                            <tr bgcolor="##999999"><td colspan="2" height="8"></td></tr>
                            <tr bgcolor="##003399"><td colspan="2" height="24"></td></tr>
                            <tr bgcolor="##999999">
                                <td colspan="2"><strong>Desarrollo Humanos: Programaci&oacute;n de Curso </strong> </td>
                            </tr>
                            <tr><td width="70">&nbsp;</td><td width="476">&nbsp;</td></tr>
                            <tr>
                                <td><span class="style2"><cf_translate key="LB_De">De</cf_translate></span></td>
                                <td><span class="style7"> #Session.Enombre# </span></td>
                            </tr>
                            <tr>
                                <td><span class="style7"><strong>
                                <cf_translate key="LB_Para">Para</cf_translate>
                                </strong></span></td>
                                <td>
                                    <span class="style7">
                                    <cfif #rsDatos.DEsexo# eq 'M'>
                                        Sr
                                    <cfelse>
                                        (a)/ Srta
                                    </cfif>
                                    : #rsDatos.DEnombre#
                                    </span>
                                </td>
                            </tr>
                            <tr><td></td><td></td></tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td><span class="style7">Informaci&oacute;n sobre curso de capacitaci&oacute;n.</span></td>
                            </tr>
                            <tr><td colspan="2">&nbsp;</td></tr>
                            <cfif not IsDefined("Request.MailArguments.Transition")>
                                <tr><td><span class="style8"></span></td>
                                    <td><span class="style7"> </span></td>
                                </tr>
                            <cfelse>
                                <tr>
                                    <td><span class="style8"></span></td>
                                    <td><span class="style7">#Request.MailArguments.info#</span></td>
                                </tr>
                            </cfif>
                            <tr>
                                <td><span class="style8"></span></td>
                                <td><span class="style8">
                                    <cfif #rsDatos.DEsexo# eq 'M'>
                                        Sr
                                    <cfelse>
                                        (a)/ Srta
                                    </cfif>
                                    : #rsDatos.DEnombre# <br>
                                    Se ha programado el curso #rsDatos.Ccodigo#-#rsDatos.Cdescripcion#,<br>
                                    el cual tiene una duraci&oacute;n total de  #rsDatos.Cduracion# horas<br>
                                    y se estar&aacute; llevando acabo del d&iacute;a <cf_locale name="date" value="#rsDatos.CFinicio#"/>  hasta el d&iacute;a <cf_locale name="date" value="#rsDatos.CFfinal#"/> <br>
                                    con un horario de #LSTimeFormat(rsDatos.CHincio, "hh:mm:tt")# a #LSTimeFormat(rsDatos.CHfin, "hh:mm:tt")#  <br>
                                    en el lugar de capacitaci&oacute;n : #rsDatos.Clugar#<br><br>
                                    Si desea matricular el curso lo puede hacer en la opci&oacute;n Automatr&iacute;cula de Cursos
                                    en Autoautogesti&oacute;n.
                                    <br><br>
                                </span></td>
                            </tr>
                        </table>
                    </cfoutput>
                </body>
                </html>
            </cfsavecontent>
            <cfset email_subject = 'Curso de Capacitacion'>
            <cfset email_to = rsDatos.DEemail>
            <!---<cfset email_remitente = "gestion@soin.co.cr">--->

            <cfif email_to NEQ ''>
				<cfquery datasource="#session.dsn#">
                    insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#FromEmail#'>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
                </cfquery>

                <cfquery name="rsIns" datasource="#session.dsn#">
                    update RHEmpleadosporCurso set RHECnotificado = 1
                    where DEid = #rsDatos.DEid#
                    	and RHCid = #rsDatos.RHCid#
                </cfquery>

            </cfif>
	</cfloop>
<cfelse>
	<!---Esto para el envio de correo--->
        <cf_dbtemp name="temp_Email" returnvariable="datos" datasource="#session.dsn#">
                <cf_dbtempcol name="RHCid"				    type="numeric"  		mandatory="no">
                <cf_dbtempcol name="DEid"				    type="numeric"  		mandatory="no">
                <cf_dbtempcol name="DEsexo"			    	type="char(1)"  	    mandatory="no">
                <cf_dbtempcol name="DEnombre"				type="varchar(255)"  	mandatory="no">
                <cf_dbtempcol name="Ccodigo"			    type="varchar(255)"		mandatory="no">
                <cf_dbtempcol name="Cdescripcion"		    type="varchar(255)"		mandatory="no">
                <cf_dbtempcol name="Cduracion"		        type="varchar(255)"		mandatory="no">
                <cf_dbtempcol name="Clugar"		        	type="varchar(255)"		mandatory="no">
                <cf_dbtempcol name="CFinicio"				type="date"	    	    mandatory="no">
                <cf_dbtempcol name="CFfinal"				type="date"	    	    mandatory="no">
                <cf_dbtempcol name="CHincio"				type="date"	    	    mandatory="no">
                <cf_dbtempcol name="CHfin"					type="date"	    	    mandatory="no">
                <cf_dbtempcol name="DEemail"				type="varchar(255)"	    mandatory="no">
        </cf_dbtemp>

    <cfquery name="rsCurso" datasource="#session.dsn#">
        select RHCid,RHCfdesde,RHCfhasta,horaini,horafin,coalesce(duracion,0) as duracion,lugar,RHCcodigo,RHCnombre,Mcodigo
        from RHCursos where RHCid=#form.RHCid#
    </cfquery>

    <cffunction name="getCentrosFuncionalesDependientes" returntype="query">
        <cfargument name="cfid" required="yes" type="numeric">
        <cfset nivel = 1>
        <cfquery name="rs1" datasource="#session.dsn#">
            select CFid, #nivel# as nivel, -1 as CFidresp
            from CFuncional
            where CFid = #arguments.cfid#
        </cfquery>
        <cfquery name="rs2" datasource="#session.dsn#">
            select CFid, CFidresp
            from CFuncional
            where Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfloop condition="1 eq 1">
            <cfquery name="rs3" dbtype="query">
                select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
                from rs1, rs2
                where rs1.nivel = #nivel#
                   and rs2.CFidresp = rs1.cfid
            </cfquery>

            <cfif rs3.RecordCount gt 0>
                <cfset nivel = nivel + 1>
                <cfquery name="rs0" dbtype="query">
                    select CFid, nivel, CFidresp from rs1
                    union
                    select CFid, nivel, CFidresp from rs3
                </cfquery>
                <cfquery name="rs1" dbtype="query">
                    select * from rs0
                </cfquery>

            <cfelse>
                <cfbreak>
            </cfif>
        </cfloop>
        <cfreturn rs1>
    </cffunction>

    <cffunction name="processcf" returntype="string">
        <cfargument name="list" type="string">
        <cfset arr = ListToArray(list)>
        <cfset arrstr = ArrayNew(1)>
        <cfloop from="1" to="#ArrayLen(arr)#" index="i">
            <cfset cf = ListToArray(arr[i],'|')>
            <cfif cf[2] eq 1>
                <cfset cfs = getCentrosFuncionalesDependientes(cf[1])>
                <cfloop query="cfs">
                    <cfset ArrayAppend(arrstr,cfid)>
                </cfloop>
            <cfelse>
                <cfset ArrayAppend(arrstr,cf[1])>
            </cfif>
        </cfloop>
        <cfreturn ArrayToList(arrstr)>
    </cffunction>

    <cffunction name="processpuesto" returntype="string">
        <cfargument name="list" type="string">
        <cfreturn convertListItemsToString(list)>
    </cffunction>

    <cffunction name="convertListItemsToString" returntype="string">
        <cfargument name="list" type="string">
        <cfset arr = ListToArray(list)>
        <cfset arrstr = ArrayNew(1)>
        <cfloop from="1" to="#ArrayLen(arr)#" index="i">
            <cfset arrstr[i] = "'" & arr[i] & "'">
        </cfloop>
        <cfreturn ArrayToList(arrstr)>
    </cffunction>
    <cfset LvarComp=0>
    <cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
    <cfquery name="rsVal" datasource="#session.dsn#">
        Select count(1) as cantidad
                from RHCompetencias A, RHConocimientosMaterias B, RHMateria C
                where  A.id 	 	= B.RHCid
                   and B.Mcodigo 	= C.Mcodigo
                   and A.Tipo 	 	= 'C'
                   and B.RHCMestado = 1
                   and C.Mactivo 	= 1
                   and A.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                   and B.RHCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.RHCid#">
    </cfquery>
    <cfset LvarComp=LvarComp+rsVal.cantidad>
    <cfquery name="rsVal" datasource="#session.dsn#">
        Select count(1) as cantidad
                from RHCompetencias A
				inner join RHHabilidadesMaterias B
					on B.RHHid = A.id
				inner join RHMateria C
					on C.Mcodigo 	= B.Mcodigo
                where A.Tipo 	 	= 'H'
                   and B.RHHMestado = 1
                   and C.Mactivo 	= 1
                   and A.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                   and C.Mcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.Mcodigo#">
    </cfquery>
    <cfset LvarComp=LvarComp+rsVal.cantidad>

    <cfif LvarComp gt 0>
        <cfquery name="rs" datasource="#session.dsn#">
            insert into #datos#(DEid,DEsexo,DEnombre,RHCid,Ccodigo,Cdescripcion,Cduracion,Clugar,CFinicio,CFfinal,CHincio,CHfin,DEemail)
            select
                lt.DEid,
                d.DEsexo,
                d.DEnombre #LvarCNCT#' '#LvarCNCT# d.DEapellido1#LvarCNCT#' '#LvarCNCT# d.DEapellido2,
                #rsCurso.RHCid#,
                '#rsCurso.RHCcodigo#',
                '#rsCurso.RHCnombre#',
                '#rsCurso.duracion#',
                '#rsCurso.lugar#',
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.RHCfdesde#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.RHCfhasta#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.horaini#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.horafin#">,
                d.DEemail
            from LineaTiempo lt
            inner join RHPlazas p
                on p.RHPid = lt.RHPid
                and p.RHPpuesto in (select  b.RHPcodigo
                                from RHConocimientosMaterias a
                                inner join RHConocimientosPuesto b
                                    on b.RHCid = a.RHCid
                                inner join RHPuestos c
                                    on c.RHPcodigo  = b.RHPcodigo
                                    and c.Ecodigo = b.Ecodigo
                                where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.Mcodigo#" null="#Len(rsCurso.Mcodigo) Is 0#">)

            inner join RHCompetenciasEmpleado ce
                on ce.DEid = lt.DEid
                and ce.tipo = 'C'
                and RHCEdominio < 100
                and ce.RHCEfdesde = (select max(B.RHCEfdesde)
                                    from RHCompetenciasEmpleado B
                                    where B.DEid    =  ce.DEid
                                      and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                      and   B.Ecodigo = ce.Ecodigo
                                      and   B.tipo = 'C'
                                      and   B.idcompetencia = ce.idcompetencia )
            inner join DatosEmpleado d
            on d.DEid=lt.DEid
            and d.Ecodigo=lt.Ecodigo
            inner join  CFuncional c
                on p.Ecodigo = c.Ecodigo
                and p.CFid = c.CFid
            left outer  join  CFuncional c2
                on c.CFidresp = c2.CFid
            where lt.Ecodigo = #session.Ecodigo#
            and exists(select 1
                        from LineaTiempo lt2
                        where lt2.Ecodigo = lt.Ecodigo
                          and lt2.DEid = lt.DEid
                          and 	<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
                                    <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= lt2.LTdesde )
                                <cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
                                    <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= lt2.LTdesde  )
                                <cfelse>
                                    <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.FECHA,'dd-mm-yyyy')#'"> between LTdesde and LThasta )
                                </cfif>
             and RHPcodigoAlt is null
             <cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
                 and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= LTdesde
            <cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
                and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= LTdesde
            <cfelse>
                 and <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.FECHA#"> between LTdesde and LThasta
            </cfif>
               <cfif form.deid gt 0>
                    and lt.DEid = #form.deid#
                </cfif>
                <cfif isdefined('form.deidlist') and len(trim(form.deidlist)) gt 0>
                    and lt.DEid in (#form.deidlist#)
                </cfif>
                <cfif isdefined('form.empleadoidlist') and len(trim(form.empleadoidlist)) gt 0>
                    and lt.DEid in (#form.empleadoidlist#)
                </cfif>
                <cfif isdefined('form.puestoidlist') and len(trim(form.puestoidlist)) gt 0>
                    and lt.RHPcodigo in (#processpuesto(form.puestoidlist)#)
                </cfif>
        </cfquery>

        <cfquery name="rs" datasource="#session.dsn#">
            insert into #datos#(DEid,DEsexo,DEnombre,RHCid,Ccodigo,Cdescripcion,Cduracion,Clugar,CFinicio,CFfinal,CHincio,CHfin,DEemail)
            select
                lt.DEid,
                d.DEsexo,
                d.DEnombre #LvarCNCT#' '#LvarCNCT# d.DEapellido1#LvarCNCT#' '#LvarCNCT# d.DEapellido2,
                #rsCurso.RHCid#,
                '#rsCurso.RHCcodigo#',
                '#rsCurso.RHCnombre#',
                '#rsCurso.duracion#',
                '#rsCurso.lugar#',
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.RHCfdesde#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.RHCfhasta#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.horaini#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.horafin#">,
                d.DEemail
            from LineaTiempo lt
            inner join RHPlazas p
                on p.RHPid = lt.RHPid
                and p.RHPpuesto in (select  b.RHPcodigo
                                from RHHabilidadesMaterias a
                                inner join RHHabilidadesPuesto b
                                    on b.RHHid = a.RHHid
                                inner join RHPuestos c
                                    on c.RHPcodigo  = b.RHPcodigo
                                    and c.Ecodigo = b.Ecodigo
                                where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.Mcodigo#" null="#Len(rsCurso.Mcodigo) Is 0#">)

            inner join RHCompetenciasEmpleado ce
                on ce.DEid = lt.DEid
                and ce.tipo = 'H'
                and RHCEdominio < 100
                and ce.RHCEfdesde = (select max(B.RHCEfdesde)
                                    from RHCompetenciasEmpleado B
                                    where B.DEid    =  ce.DEid
                                      and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                      and   B.Ecodigo = ce.Ecodigo
                                      and   B.tipo = 'H'
                                      and   B.idcompetencia = ce.idcompetencia )
            inner join DatosEmpleado d
            on d.DEid=lt.DEid
            and d.Ecodigo=lt.Ecodigo
            inner join  CFuncional c
                on p.Ecodigo = c.Ecodigo
                and p.CFid = c.CFid
            left outer  join  CFuncional c2
                on c.CFidresp = c2.CFid
            where lt.Ecodigo = #session.Ecodigo#
            <cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
                and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= LTdesde
            <cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
                and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= LTdesde
            <cfelse>
                and <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.FECHA#"> between LTdesde and LThasta
            </cfif>
            and exists(select 1
                        from LineaTiempo lt2
                        where lt2.Ecodigo = lt.Ecodigo
                          and lt2.DEid = lt.DEid
                          and 	<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
                                    <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= lt2.LTdesde )
                                <cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
                                    <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= lt2.LTdesde  )
                                <cfelse>
                                    <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.FECHA,'dd-mm-yyyy')#'"> between LTdesde and LThasta )
                                </cfif>
            and RHPcodigoAlt is null

                <cfif form.deid gt 0>
                    and lt.DEid = #form.deid#
                </cfif>
                <cfif isdefined('form.deidlist') and len(trim(form.deidlist)) gt 0>
                    and lt.DEid in (#form.deidlist#)
                </cfif>
                <cfif isdefined('form.empleadoidlist') and len(trim(form.empleadoidlist)) gt 0>
                    and lt.DEid in (#form.empleadoidlist#)
                </cfif>
                <cfif isdefined('form.puestoidlist') and len(trim(form.puestoidlist)) gt 0>
                    and lt.RHPcodigo in (#processpuesto(form.puestoidlist)#)
                </cfif>
        </cfquery>
    <cfelse>
        <cfquery name="rs" datasource="#session.dsn#">
           insert into #datos#(DEid,DEsexo,DEnombre,RHCid,Ccodigo,Cdescripcion,Cduracion,Clugar,CFinicio,CFfinal,CHincio,CHfin,DEemail)
            (select distinct
                a.DEid,
                d.DEsexo,
                d.DEnombre #LvarCNCT#' '#LvarCNCT# d.DEapellido1#LvarCNCT#' '#LvarCNCT# d.DEapellido2,
                #rsCurso.RHCid#,
                '#rsCurso.RHCcodigo#',
                '#rsCurso.RHCnombre#',
                '#rsCurso.duracion#',
                '#rsCurso.lugar#',
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.RHCfdesde#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.RHCfhasta#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.horaini#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#rsCurso.horafin#">,
                d.DEemail
            from LineaTiempo a
            inner join  RHPlazas b
                on a.RHPid = b.RHPid
                and b.Ecodigo = a.Ecodigo
            inner join DatosEmpleado d
            on d.DEid=a.DEid
            and d.Ecodigo=a.Ecodigo
            inner join  CFuncional c
                on b.Ecodigo = c.Ecodigo
                and b.CFid = c.CFid
            left outer  join  CFuncional c2
                on c.CFidresp = c2.CFid
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and a.LTid = (select Max(lt2.LTid) from LineaTiempo lt2 inner join RHTipoAccion ta2 on ta2.RHTid = lt2.RHTid and ta2.RHTcomportam in (1,6) where lt2.DEid = a.DEid )

            <cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
                and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= LTdesde
            <cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
                and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= LTdesde
            <cfelse>
                and <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.FECHA#"> between LTdesde and LThasta
            </cfif>
			and RHPcodigoAlt is null
                <cfif form.deid gt 0>
                    and a.DEid = #form.deid#
                </cfif>
                <cfif isdefined('form.deidlist') and len(trim(form.deidlist)) gt 0>
                    and a.DEid in (#form.deidlist#)
                </cfif>
                <cfif isdefined('form.empleadoidlist') and len(trim(form.empleadoidlist)) gt 0>
                    and a.DEid in (#form.empleadoidlist#)
                </cfif>
                <cfif isdefined('form.puestoidlist') and len(trim(form.puestoidlist)) gt 0>
                    and a.RHPcodigo in (#processpuesto(form.puestoidlist)#)
                </cfif>
                <cfif isdefined('form.cfidlist') and LEN(TRIM(form.cfidlist)) GT 0>
                  and b.CFid in (#processcf(form.cfidlist)#)
                </cfif>
                )
        </cfquery>
    </cfif>

    <cfquery name="rsDatos" datasource="#session.dsn#">
        select DEid,DEsexo,DEnombre,RHCid,Ccodigo,DEemail,
        Cdescripcion,Cduracion,Clugar,CFinicio,CFfinal,CHincio,CHfin
        from #datos#
        where DEid not in (select DEid from RHEmpleadosporCurso where DEid =#datos#.DEid and RHCid =#datos#.RHCid)
        group by DEid,DEsexo,DEnombre,RHCid,Ccodigo,DEemail,
        Cdescripcion,Cduracion,Clugar,CFinicio,CFfinal,CHincio,CHfin
    </cfquery>

    <cfloop query="rsDatos">
        <cfquery name="rsVer" datasource="#session.dsn#">
            select count(1) as cantidad from RHEmpleadosporCurso
            where DEid=#rsDatos.DEid#
            and RHCid=#rsDatos.RHCid#
            and Ecodigo=#session.Ecodigo#
        </cfquery>
        <cfif rsVer.cantidad eq 0>
            <cfquery name="rsIns" datasource="#session.dsn#">
                insert into RHEmpleadosporCurso(DEid,RHCid,Ecodigo,RHECnotificado)
                values(#rsDatos.DEid#,#rsDatos.RHCid#,#session.Ecodigo#,0)
            </cfquery>
        </cfif>
    </cfloop>
</cfif>

<cflocation url="participantes.cfm?RHCid=#form.RHCid#">
