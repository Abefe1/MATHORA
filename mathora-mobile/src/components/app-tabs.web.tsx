import {
  Tabs,
  TabList,
  TabTrigger,
  TabSlot,
  TabTriggerSlotProps,
  TabListProps,
} from 'expo-router/ui';
import { Pressable, View, StyleSheet, Text } from 'react-native';

export default function AppTabs() {
  return (
    <View style={styles.pageOuterWrapper}>
      {/* Centered Mobile Device Viewport */}
      <View style={styles.phoneFrame}>
        {/* Mobile Device Status Bar Notch */}
        <View style={styles.notchHeader}>
          <View style={styles.notchSpeaker} />
          <Text style={styles.notchTimeText}>9:41</Text>
        </View>

        <Tabs style={styles.tabContainer}>
          <TabSlot style={{ flex: 1, backgroundColor: '#090D16' }} />
          <TabList asChild>
            <CustomTabList>
              <TabTrigger name="home" href="/" asChild>
                <TabButton icon="🏠">Home</TabButton>
              </TabTrigger>
              <TabTrigger name="explore" href="/explore" asChild>
                <TabButton icon="📚">Topics</TabButton>
              </TabTrigger>
              <TabTrigger name="squads" href="/squads" asChild>
                <TabButton icon="👥">Squads</TabButton>
              </TabTrigger>
              <TabTrigger name="mock-exam" href="/mock-exam" asChild>
                <TabButton icon="⏱️">Mock</TabButton>
              </TabTrigger>
              <TabTrigger name="settings" href="/settings" asChild>
                <TabButton icon="⚙️">Settings</TabButton>
              </TabTrigger>
            </CustomTabList>
          </TabList>
        </Tabs>

        {/* Mobile Home Bar Indicator */}
        <View style={styles.homeBarContainer}>
          <View style={styles.homeBarLine} />
        </View>
      </View>
    </View>
  );
}

export function TabButton({ children, icon, isFocused, ...props }: TabTriggerSlotProps & { icon?: string }) {
  return (
    <Pressable {...props} style={({ pressed }) => [styles.tabFlexItem, pressed && styles.pressed]}>
      <View style={[styles.tabButtonView, isFocused && styles.tabButtonActive]}>
        <Text style={styles.tabIcon}>{icon}</Text>
        <Text style={[styles.tabText, isFocused && styles.tabTextActive]}>
          {children}
        </Text>
      </View>
    </Pressable>
  );
}

export function CustomTabList(props: TabListProps) {
  return (
    <View {...props} style={styles.tabListContainer}>
      <View style={styles.innerContainer}>
        {props.children}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  pageOuterWrapper: {
    flex: 1,
    backgroundColor: '#020617',
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 12,
    paddingHorizontal: 8,
  },
  phoneFrame: {
    width: '100%',
    maxWidth: 440,
    height: '100%',
    maxHeight: 900,
    backgroundColor: '#090D16',
    borderRadius: 36,
    borderWidth: 8,
    borderColor: '#1E293B',
    overflow: 'hidden',
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 12 },
    shadowOpacity: 0.8,
    shadowRadius: 24,
    position: 'relative',
  },
  notchHeader: {
    height: 32,
    backgroundColor: '#090D16',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    borderBottomWidth: 1,
    borderColor: '#0F172A',
  },
  notchSpeaker: {
    width: 60,
    height: 4,
    backgroundColor: '#334155',
    borderRadius: 2,
  },
  notchTimeText: {
    color: '#94A3B8',
    fontSize: 11,
    fontWeight: 'bold',
  },
  tabContainer: {
    flex: 1,
    backgroundColor: '#090D16',
  },
  tabListContainer: {
    width: '100%',
    backgroundColor: '#0F172AD0',
    borderTopWidth: 1,
    borderColor: '#1E293B',
    paddingVertical: 6,
    paddingHorizontal: 8,
  },
  innerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    width: '100%',
  },
  tabFlexItem: {
    flex: 1,
    alignItems: 'center',
  },
  pressed: {
    opacity: 0.7,
  },
  tabButtonView: {
    alignItems: 'center',
    paddingVertical: 4,
    paddingHorizontal: 6,
    borderRadius: 10,
  },
  tabButtonActive: {
    backgroundColor: '#1E1B4B',
  },
  tabIcon: {
    fontSize: 16,
  },
  tabText: {
    color: '#64748B',
    fontSize: 10,
    fontWeight: '600',
    marginTop: 2,
  },
  tabTextActive: {
    color: '#F59E0B',
    fontWeight: 'bold',
  },
  homeBarContainer: {
    height: 16,
    backgroundColor: '#090D16',
    alignItems: 'center',
    justifyContent: 'center',
  },
  homeBarLine: {
    width: 120,
    height: 4,
    backgroundColor: '#475569',
    borderRadius: 2,
  },
});
