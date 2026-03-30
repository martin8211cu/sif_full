<!--- /
******************************************
CARGA INICIAL DE HPAGOSEMPLEADO
	FECHA    DE    CREACIÓN:    22/03/2007
	CREADO   POR:   DORIAN   ABARCA  GÓMEZ
******************************************
*********************************
Archivo   de  generaración  final
Este   archivo   requiere es para 
realizar  la  copia  final  de la 
tabla temporal a la tabla real.
*********************************
--->
<cfquery datasource="#Gvar.Conexion#" name="LZ">
	insert into HPagosEmpleado
		(DEid, RCNid, LTid, RHJid, PEhjornada, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, RHTid, Ocodigo, Dcodigo, RHPid, 
		RHPcodigo, RVid, LTporcplaza, Tcodigo, PEtiporeg, Mcodigo, PEmontoorigen, CPmes, CPperiodo, PEsalarioref, PEsalariobc )
	select 
		b.DEid, c.RCNid, 
		j.LTid, j.RHJid,  
		isnull(d.RHJhoradiaria,0), #Gvar.table_name#.CDRHHPEfcorteinic, 
		#Gvar.table_name#.CDRHHPEfcortefin, #Gvar.table_name#.CDRHHPEsalario, 
		#Gvar.table_name#.CDRHHPEdias, #Gvar.table_name#.CDRHHPEdevengado, 
		0, 
        case coalesce(#Gvar.table_name#.CDRHTcodigo,'0')
        	when '0' then j.RHTid
         	else
            (select ta.RHTid
                from RHTipoAccion ta
                where ta.Ecodigo = #Gvar.Ecodigo#
                and ta.RHTcodigo = #Gvar.table_name#.CDRHTcodigo)
        end, 
		j.Ocodigo, j.Dcodigo, 
		j.RHPid, j.RHPcodigo, 
		j.RVid, j.LTporcplaza, 
		#Gvar.table_name#.CDRHHPEnomina, 0, 
		j.Mcodigo, null,
        month(#Gvar.table_name#.CDRHHPEfdesde), 
        year(#Gvar.table_name#.CDRHHPEfdesde),
        isnull(#Gvar.table_name#.CDRHHPEsalarioref,0)
        CDRHHPEsalarioref, CDRHHPEsalariobc 
        
	from #Gvar.table_name#
		inner join DatosEmpleado b
		on b.Ecodigo = #Gvar.Ecodigo#
		and b.DEidentificacion = #Gvar.table_name#.CDRHHPEidentificacion
		
		inner join LineaTiempo j
		on j.DEid = b.DEid
		and j.LTid = (select min(x.LTid) from LineaTiempo x where x.DEid = b.DEid)

<!---	    and #Gvar.table_name#.CDRHHPEfdesde <= j.LThasta 
			and coalesce(#Gvar.table_name#.CDRHHPEfhasta,'61000101') >= j.LTdesde
--->			
		inner join RHJornadas d
		on d.RHJid = j.RHJid
			
		inner join HRCalculoNomina c
		on c.Ecodigo = b.Ecodigo
		and c.RCdesde = #Gvar.table_name#.CDRHHPEfdesde
		and c.RChasta = #Gvar.table_name#.CDRHHPEfhasta
		and c.Tcodigo = #Gvar.table_name#.CDRHHPEnomina
		
	where CDPcontrolv = 1
	and CDPcontrolg = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>


<!---select *
from RHTipoAccion
where Ecodigo = 1262
and RHTcodigo = '01'--->