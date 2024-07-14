import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

public class Main {
    static class Node {
        long cycle;
        long num;

        Node(long cycle, long num) {
            this.cycle = cycle;
            this.num = num;
        }
    }

    public static void main(String[] args) {
//        while(true){
            Map<String, Node> m = new HashMap<>();
            List<String> v = new ArrayList<>();

            // Function to read and process file
            organizedata(m, v);

            // Function to write to SQL file
            writeSQL(m);
//        }
    }

    public static void organizedata(Map<String, Node> m, List<String> v) {
        BufferedReader file2 = null;

        try {
            file2 = new BufferedReader(new FileReader("/home/changli/tools/perf.txt"));
            String _str;
            long cycle = 0;
            while ((_str = file2.readLine()) != null) {
                if (_str.isEmpty() || _str.indexOf('.') == -1 || _str.indexOf("[unknown]") != -1) {
                    continue;
                }
                else if (_str.indexOf('+') == -1) {
                    for (String name : v) {
                        Node node = m.getOrDefault(name, new Node(0, 0));
                        node.cycle += cycle / v.size();
                        node.num++;
                        m.put(name, node);
                    }
                    v.clear();

                    int pos = _str.indexOf(".");
                    pos += 7;
                    int l = 0, len = 0, flag = 0;
                    for (int i = pos + 1; i <= pos + 20; i++) {
                        if (_str.charAt(i) != ' ' && flag == 0) {
                            flag = 1;
                            l = i;
                        }
                        if (_str.charAt(i) == ' ' && flag != 0) {
                            len = i - l;
                            break;
                        }
                    }
                    String tmp = _str.substring(l, l + len);
                    cycle = Long.parseLong(tmp);
                }
                else {
                    if (_str.indexOf('.') == -1) {
                        continue;
                    }
                    int pos = _str.indexOf("+");
                    int l = 0;
                    for (int i = pos; i >= 0; i--) {
                        if (_str.charAt(i) == ' ') {
                            l = i + 1;
                            break;
                        }
                    }
                    String name = _str.substring(l, pos);
                    v.add(name);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (file2 != null) {
                    file2.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    public static void writeSQL(Map<String, Node> m) {
        try (FileWriter fw = new FileWriter("/home/changli/tools/function.sql")) {
            for (Map.Entry<String, Node> entry : m.entrySet()) {
                fw.write("insert into function values(");
                fw.write("'" + entry.getKey() + "',");
                fw.write(entry.getValue().num + ",");
                fw.write(entry.getValue().cycle + ");\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
