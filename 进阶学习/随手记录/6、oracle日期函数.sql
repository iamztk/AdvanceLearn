trunc()�� to_char()�� to_date() ������ʹ�á�

1��trunc():

	--��ȡ��ǰʱ�� [���أ�2021-06-22 14:37:22]
	select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')from dual;

	--sysdate : 2021-06-22 14:37:22

	--���ص�ǰ������ [���أ�2021/6/22]
	select trunc(sysdate) from dual;
	--���ر���ȵ�һ�� [���أ�2021/1/1]
	select trunc(sysdate, 'yyyy') from dual;
	--���ر����ȵ�һ�� [���أ�2021/4/1]
	select trunc(sysdate, 'q') from dual;
	--���ر��µĵ�һ�� [���أ�2021/6/1]
	select trunc(sysdate, 'month') from dual;
	--���� ��  
	select trunc(sysdate, '') from dual;
	--���������յ�����
	select trunc(sysdate, 'day') from dual;
	select trunc(sysdate, 'd') from dual;


	--���ص�ǰ������ ʱ���� [���أ�2021-06-22 00:00:00]
	--��Ϊtrunc(sysdate) �Ѿ���ʱ�������ȡ���ˣ�����to_char()��õ�����
	--û��ʱ����ģ���Ȼ��� 00��00��00
	select to_char(trunc(sysdate), 'yyyy-mm-dd hh24:mi:ss') from dual;


2��to_char():  --�����ڸ�ʽתΪ�ַ�����ʽ
	--SQL�в����ִ�Сд��  MM��mm��Ϊ����ͬ�ĸ�ʽ   
	select to_char(sysdate, 'YYYY-mm-dd hh24:mi:ss') from dual;

	select to_char(sysdate, 'yyyy-MM-dd hh24:MI:ss') from dual;

	select to_char(sysdate, 'yyyy-mm-DD hh24:mI:SS') from dual;
	--����������䣬���д�д��Сд�����Ƿ��صĽ����Ϊ��2021-06-22 14:51:06

	--���ʱ����ĸ�ʽ��
	--��ʽһ�� ��24H�Ʒ��� Сʱ  [���أ�2021-06-22 14:51:06]
	select to_char(sysdate, 'yyyy-mm-DD hh24:mI:SS') from dual;
	--��ʽ���� ��12H�Ʒ��� Сʱ  [���أ�2021-06-22 02:52:55]
	select to_char(sysdate, 'yyyy-mm-dd hh:mi:ss') from dual;
	
	--��ȡ sysdate�е� ��  [���أ�2021]
	select to_char(sysdate, 'yyyy') from  dual;
	--��ȡ sysdate�е� ��  [���أ�06]
	select to_char(sysdate, 'mm') from  dual;
	--��ȡ sysdate�е� ��  [���أ�22]
	select to_char(sysdate, 'dd') from  dual;
	--��ȡ sysdate�е� ʱ  [���أ�15]
	select to_char(sysdate, 'hh24') from  dual;
	--��ȡ sysdate�е� ʱ  [���أ�03]
	select to_char(sysdate, 'hh') from  dual;
	--��ȡ sysdate�е� ��  [���أ�02]
	select to_char(sysdate, 'mi') from  dual;
	--��ȡ sysdate�е� ��  [���أ�52]
	select to_char(sysdate, 'ss') from  dual;
	
	--���ص�ǰ�����ǵڼ�����  [���أ�2�� ����6���ǵ�2����]
	select to_char(sysdate, 'q') from dual;

	--���ص�ǰ�����ڼ�
	select to_char(sysdate, 'day') from  dual;
	--���� 2021/1/1 - 2020/1/1 ֮���������������СΪ������ С����Ϊ����
	select floor(date'2021-01-01' - date'2020-01-01') from dual;
	
3��to_date(): --���ַ�����ʽתΪ���ڸ�ʽ
	--���� ���ڣ�2021/3/2
	select to_date('20210302', 'yyyy-mm-dd') from dual;