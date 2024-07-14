#include <bits/stdc++.h>
#define int long long
#define Inf 1e9 
using namespace std;
struct node{
	int cycle;
	int num;
}; 
map<string,node> m;
vector<string> v;
void organizedata()
{
	ifstream file2;
	string _str;
	file2.open("perf2.txt");
	if (file2.is_open())
	{
		cout << "open successfully" << endl;
		if (file2.is_open())
		{
			int cycle = 0;
			int num = 0;
			while (getline(file2, _str))
			{
				if(_str.size() == 0 || _str.find('.') >= Inf || _str.find("[unknown]") <= Inf){
					continue;
				}
				else if(_str.find('+') >= Inf){
					for(int i = 0;i < v.size();i++){
						m[v[i]].cycle += cycle/v.size();
						m[v[i]].num += 1;
					}
					while(v.size() > 0) v.pop_back();
					int pos = _str.find(".");
					pos += 7;
					int l,len = 0,flag = 0;
					for(int i = pos+1;i <= pos+20;i++){
						if(_str[i] != ' ' && !flag){
							flag = 1;
							l = i;
						}
						if(_str[i] == ' ' && flag){
							len = i-l;
							break;
						}
					}
					string tmp = _str.substr(l,len); 
					cycle = atoll(tmp.c_str());
				}
				else{
					if(_str.find('.') >= Inf) continue;
					int pos = _str.find("+");
					int l;
					for(int i = pos;i >= 0;i--){
						if(_str[i] == ' '){
							l = i+1;
							break;
						}
					}
					string name = _str.substr(l,pos-l);
					v.push_back(name);
				}
			}
			
		}
		
	}
}
void writeSQL(){
	FILE *fp;
    int i, d;
 
    fp = fopen("function.sql","w");
    if(fp == NULL){
        printf("File cannot open! " );
        exit(0);
    }
	for(auto i:m){
		fprintf(fp,"insert into function values(");
        fprintf(fp,"\'%s\',", i.first.c_str());
        fprintf(fp,"%lld,", i.second.num);
        fprintf(fp,"%lld);\n", i.second.cycle);
    }
} 
signed main(){
	cout << fixed << setprecision(6);
	organizedata();
	writeSQL();
}
